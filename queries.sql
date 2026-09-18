-- ============================================
-- JOIN QUERY 1
-- List all orders with customer name and city.
-- ============================================
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;


-- ============================================
-- JOIN QUERY 2
-- List every order item with product name,
-- category, price, and quantity.
-- ============================================

SELECT
    oi.order_item_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;


-- ============================================
-- JOIN QUERY 3
-- List all customers and their orders,
-- including customers with no orders.
-- ============================================

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;


-- ============================================
-- CTE QUERY 1
-- Calculate each customer's total spending
-- and return customers above average spending.
-- ============================================

WITH customer_totals AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * p.price) AS total_spend
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    ct.total_spend
FROM customer_totals ct
JOIN customers c
    ON ct.customer_id = c.customer_id
WHERE ct.total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY ct.total_spend DESC;


-- ============================================
-- WINDOW QUERY 1
-- Rank customers by total amount spent.
-- Highest spender receives rank 1.
-- ============================================

SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * p.price) DESC
    ) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY spending_rank;


-- ============================================
-- WINDOW QUERY 2
-- Number each customer's orders in the
-- order they were placed.
-- ============================================

SELECT
    o.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date
    ) AS order_number
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY
    o.customer_id,
    o.order_date;


-- ============================================
-- WINDOW QUERY 3
-- Show a running total of revenue over time.
-- ============================================

SELECT
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue,
    SUM(SUM(oi.quantity * p.price)) OVER (
        ORDER BY o.order_date
    ) AS running_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;


-- ============================================
-- WINDOW QUERY 4
-- Show the number of days between the current
-- and previous order for each customer.
-- ============================================

SELECT
    customer_id,
    customer_name,
    order_id,
    order_date,
    order_date - LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS days_between_orders
FROM (
    SELECT
        o.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
) AS customer_orders
ORDER BY customer_id, order_date;


-- 