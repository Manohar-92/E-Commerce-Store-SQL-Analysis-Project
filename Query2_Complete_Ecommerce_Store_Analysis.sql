-- =====================================================================
--  QUERY 2: COMPLETE Ecommerce_Store ANALYSIS
--  A single-shot business summary report combining all the key
--  metrics of the store into one result set (like a mini dashboard).
-- =====================================================================

WITH
revenue_summary AS (
    SELECT SUM(amount) AS total_revenue, COUNT(*) AS total_payments
    FROM payments
),
order_summary AS (
    SELECT
        COUNT(*)                                            AS total_orders,
        COUNT(*) FILTER (WHERE status = 'Delivered')        AS delivered_orders,
        COUNT(*) FILTER (WHERE status = 'Cancelled')        AS cancelled_orders,
        COUNT(*) FILTER (WHERE status = 'Returned')         AS returned_orders,
        COUNT(*) FILTER (WHERE status = 'Processing')       AS processing_orders,
        COUNT(*) FILTER (WHERE status = 'Shipped')          AS shipped_orders
    FROM orders
),
customer_summary AS (
    SELECT COUNT(*) AS total_customers FROM customers
),
repeat_customers AS (
    SELECT COUNT(*) AS repeat_customer_count FROM (
        SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(*) > 1
    ) t
),
product_summary AS (
    SELECT COUNT(*) AS total_products, SUM(stock_quantity) AS total_stock_units
    FROM products
),
low_stock AS (
    SELECT COUNT(*) AS low_stock_products
    FROM products WHERE stock_quantity < reorder_level
),
review_summary AS (
    SELECT COUNT(*) AS total_reviews, ROUND(AVG(rating)::numeric, 2) AS avg_rating
    FROM reviews
),
top_category AS (
    SELECT c.category_name
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
    ORDER BY SUM(oi.line_total) DESC
    LIMIT 1
),
top_product AS (
    SELECT p.product_name
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name
    ORDER BY SUM(oi.quantity) DESC
    LIMIT 1
),
top_customer AS (
    SELECT cu.first_name || ' ' || cu.last_name AS customer_name
    FROM payments pay
    JOIN orders o ON pay.order_id = o.order_id
    JOIN customers cu ON o.customer_id = cu.customer_id
    GROUP BY cu.customer_id, cu.first_name, cu.last_name
    ORDER BY SUM(pay.amount) DESC
    LIMIT 1
)

SELECT metric, value FROM (
    VALUES
        ('Total Revenue',            (SELECT '$' || TO_CHAR(total_revenue, 'FM999,999,990.00') FROM revenue_summary)),
        ('Total Orders',             (SELECT total_orders::text FROM order_summary)),
        ('  - Delivered',            (SELECT delivered_orders::text FROM order_summary)),
        ('  - Shipped',              (SELECT shipped_orders::text FROM order_summary)),
        ('  - Processing',           (SELECT processing_orders::text FROM order_summary)),
        ('  - Cancelled',            (SELECT cancelled_orders::text FROM order_summary)),
        ('  - Returned',             (SELECT returned_orders::text FROM order_summary)),
        ('Average Order Value',      (SELECT '$' || TO_CHAR(total_revenue / NULLIF(total_payments,0), 'FM999,990.00') FROM revenue_summary)),
        ('Total Customers',          (SELECT total_customers::text FROM customer_summary)),
        ('Repeat Customers',         (SELECT repeat_customer_count::text FROM repeat_customers)),
        ('Total Products',           (SELECT total_products::text FROM product_summary)),
        ('Total Stock Units',        (SELECT total_stock_units::text FROM product_summary)),
        ('Low-Stock Products',       (SELECT low_stock_products::text FROM low_stock)),
        ('Total Reviews',            (SELECT total_reviews::text FROM review_summary)),
        ('Average Product Rating',   (SELECT avg_rating::text || ' / 5' FROM review_summary)),
        ('Best-Selling Category',    (SELECT category_name FROM top_category)),
        ('Best-Selling Product',     (SELECT product_name FROM top_product)),
        ('Top Customer (by spend)',  (SELECT customer_name FROM top_customer))
) AS report(metric, value);
