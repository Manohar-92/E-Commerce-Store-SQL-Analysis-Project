-- =====================================================================
--  QUERY 1: COMPLETE / FULL DATA OF Ecommerce_Store
--  Joins ALL 10 tables into one master result set — every order line
--  item shown together with its product, category, supplier, customer,
--  employee, shipper, payment and (if it exists) review details.
-- =====================================================================

SELECT
    o.order_id,
    o.order_date,
    o.ship_date,
    o.status                       AS order_status,

    cu.customer_id,
    cu.first_name || ' ' || cu.last_name   AS customer_name,
    cu.email                       AS customer_email,
    cu.city,
    cu.state,
    cu.country                     AS customer_country,

    e.employee_id,
    e.first_name || ' ' || e.last_name     AS employee_name,
    e.title                        AS employee_title,

    sh.shipper_name,

    p.product_id,
    p.product_name,
    cat.category_name,
    sup.supplier_name,

    oi.quantity,
    oi.unit_price,
    oi.discount_percent,
    oi.line_total,

    pay.payment_method,
    pay.amount                     AS payment_amount,

    r.rating                       AS review_rating,
    r.review_text

FROM orders o
JOIN customers   cu  ON o.customer_id  = cu.customer_id
JOIN employees   e   ON o.employee_id  = e.employee_id
JOIN shippers    sh  ON o.shipper_id   = sh.shipper_id
JOIN order_items oi  ON o.order_id     = oi.order_id
JOIN products    p   ON oi.product_id  = p.product_id
JOIN categories  cat ON p.category_id  = cat.category_id
JOIN suppliers   sup ON p.supplier_id  = sup.supplier_id
LEFT JOIN payments pay ON o.order_id   = pay.order_id
LEFT JOIN reviews  r   ON r.product_id = p.product_id AND r.customer_id = cu.customer_id

ORDER BY o.order_id;
