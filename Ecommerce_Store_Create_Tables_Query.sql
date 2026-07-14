-- =====================================================================
--  E-COMMERCE STORE ANALYSIS - SQL PROJECT
--  Database creation script
--  Tables: categories, suppliers, products, customers, employees,
--          shippers, orders, order_items, payments, reviews
-- =====================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_store;
USE ecommerce_store;

-- ---------------------------------------------------------------------
-- 1. CATEGORIES
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    category_id     INT PRIMARY KEY,
    category_name   VARCHAR(100) NOT NULL
);

-- ---------------------------------------------------------------------
-- 2. SUPPLIERS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
    supplier_id     INT PRIMARY KEY,
    supplier_name   VARCHAR(150) NOT NULL,
    contact_email   VARCHAR(150),
    phone           VARCHAR(30),
    country         VARCHAR(100)
);

-- ---------------------------------------------------------------------
-- 3. PRODUCTS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(150) NOT NULL,
    category_id     INT,
    supplier_id     INT,
    unit_price      DECIMAL(10,2) NOT NULL,
    stock_quantity  INT NOT NULL,
    reorder_level   INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- ---------------------------------------------------------------------
-- 4. CUSTOMERS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(150) UNIQUE,
    phone           VARCHAR(30),
    address         VARCHAR(200),
    city            VARCHAR(100),
    state           VARCHAR(100),
    country         VARCHAR(100),
    signup_date     DATE
);

-- ---------------------------------------------------------------------
-- 5. EMPLOYEES  (self-referencing manager_id)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id     INT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    title           VARCHAR(100),
    email           VARCHAR(150) UNIQUE,
    hire_date       DATE,
    manager_id      INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- ---------------------------------------------------------------------
-- 6. SHIPPERS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS shippers;
CREATE TABLE shippers (
    shipper_id      INT PRIMARY KEY,
    shipper_name    VARCHAR(150) NOT NULL,
    phone           VARCHAR(30)
);

-- ---------------------------------------------------------------------
-- 7. ORDERS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT,
    employee_id     INT,
    shipper_id      INT,
    order_date      DATE NOT NULL,
    ship_date       DATE,
    status          VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id)
);

-- ---------------------------------------------------------------------
-- 8. ORDER_ITEMS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY,
    order_id        INT,
    product_id      INT,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    discount_percent INT DEFAULT 0,
    line_total      DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ---------------------------------------------------------------------
-- 9. PAYMENTS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id      INT PRIMARY KEY,
    order_id        INT,
    payment_date    DATE,
    payment_method  VARCHAR(50),
    amount          DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ---------------------------------------------------------------------
-- 10. REVIEWS
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    review_id       INT PRIMARY KEY,
    product_id      INT,
    customer_id     INT,
    rating          INT CHECK (rating BETWEEN 1 AND 5),
    review_text     VARCHAR(500),
    review_date     DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =====================================================================
--  LOAD DATA (MySQL example - adjust path & use LOCAL if needed)
-- =====================================================================
-- LOAD DATA LOCAL INFILE 'categories.csv'   INTO TABLE categories   FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'suppliers.csv'    INTO TABLE suppliers    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'products.csv'     INTO TABLE products     FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'customers.csv'    INTO TABLE customers    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'employees.csv'    INTO TABLE employees    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'shippers.csv'     INTO TABLE shippers     FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'orders.csv'       INTO TABLE orders       FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'order_items.csv'  INTO TABLE order_items  FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'payments.csv'     INTO TABLE payments     FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
-- LOAD DATA LOCAL INFILE 'reviews.csv'      INTO TABLE reviews      FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
