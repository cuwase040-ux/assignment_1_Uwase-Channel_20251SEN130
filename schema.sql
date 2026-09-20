-- 1. CREATE TABLES
-- ============================================
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);

-- ============================================
-- 2. INSERT CUSTOMERS
-- ============================================

INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(1, 'Alice Mukamana', 'alice@gmail.com', 'Kigali'),
(2, 'Brian Niyonzima', 'brian@gmail.com', 'Huye'),
(3, 'Claudine Uwimana', 'claudine@gmail.com', 'Musanze'),
(4, 'David Habimana', 'david@gmail.com', 'Kigali'),
(5, 'Esther Uwamahoro', 'esther@gmail.com', 'Rubavu'),
(6, 'Felix Ishimwe', 'felix@gmail.com', 'Kigali');

-- ============================================
-- 3. INSERT PRODUCTS
-- ============================================

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Milk 1L', 'Dairy', 1200.00),
(2, 'Bread', 'Bakery', 1500.00),
(3, 'Cheese 500g', 'Dairy', 5500.00),
(4, 'Rice 5kg', 'Grains', 7500.00),
(5, 'Cooking Oil 1L', 'Cooking', 3000.00),
(6, 'Sugar 1kg', 'Grains', 1800.00),
(7, 'Biscuits Pack', 'Bakery', 2000.00),
(8, 'Yogurt 500ml', 'Dairy', 2500.00);

-- ============================================
-- 4. INSERT ORDERS
-- ============================================

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2026-08-01'),
(2, 2, '2026-08-02'),
(3, 3, '2026-08-03'),
(4, 1, '2026-08-05'),
(5, 4, '2026-08-06'),
(6, 5, '2026-08-07'),
(7, 2, '2026-08-09'),
(8, 3, '2026-08-10'),
(9, 1, '2026-08-12'),
(10, 4, '2026-08-14'),
(11, 5, '2026-08-16'),
(12, 2, '2026-08-18'),
(13, 3, '2026-08-20'),
(14, 4, '2026-08-22'),
(15, 1, '2026-08-25');

-- ============================================
-- 5. INSERT ORDER ITEMS
-- ============================================

INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 4, 1),
(4, 2, 6, 2),
(5, 3, 3, 1),
(6, 3, 8, 2),
(7, 4, 5, 2),
(8, 4, 7, 3),
(9, 5, 4, 2),
(10, 5, 5, 1),
(11, 6, 1, 3),
(12, 6, 8, 1),
(13, 7, 2, 2),
(14, 7, 6, 1),
(15, 8, 3, 2),
(16, 9, 4, 1),
(17, 9, 5, 2),
(18, 10, 7, 4),
(19, 11, 1, 2),
(20, 11, 2, 2),
(21, 12, 4, 1),
(22, 12, 6, 3),
(23, 13, 8, 2),
(24, 14, 3, 1),
(25, 15, 5, 3);

-- 