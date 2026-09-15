# assignment_1_Uwase-Channel_20251SEN130
# Sunrise Supermarket — Assignment 1

## Student Information

**Name:** Channel Uwase
**Student ID:** 20251SEN130
**Repository:** `assignment_1_channel-uwase-20251SEN130`

---

## 1. Business Scenario

Sunrise Supermarket sells different products to customers. Customers place orders, and each order can contain one or more products. The supermarket stores information about customers, products, orders, and the individual items included in each order.

Management wants to use the database to better understand:

* Who their customers are
* What products customers purchase
* How much each customer spends
* Which customers spend the most
* How frequently customers place orders
* How sales revenue changes over time
* The number of days between customer orders

This assignment uses SQL queries involving **JOINs, Common Table Expressions (CTEs), and window functions** to analyze the supermarket's sales data.

---

## 2. DBMS Used

**Database Management System:** PostgreSQL

**SQL Tool:** pgAdmin 4 / PostgreSQL psql

The database was created and queried using PostgreSQL.

---

## 3. Database Tables

The database contains four main tables:

### Customers

Stores information about customers.

| Column        | Description                           |
| ------------- | ------------------------------------- |
| customer_id   | Unique customer identification number |
| customer_name | Customer's name                       |
| email         | Customer's email address              |
| city          | Customer's city                       |

### Products

Stores information about products sold by Sunrise Supermarket.

| Column       | Description                          |
| ------------ | ------------------------------------ |
| product_id   | Unique product identification number |
| product_name | Name of the product                  |
| category     | Product category                     |
| price        | Product selling price                |

### Orders

Stores information about customer orders.

| Column      | Description                        |
| ----------- | ---------------------------------- |
| order_id    | Unique order identification number |
| customer_id | Customer who placed the order      |
| order_date  | Date the order was placed          |

### Order Items

Stores the individual products contained in each order.

| Column        | Description                             |
| ------------- | --------------------------------------- |
| order_item_id | Unique order-item identification number |
| order_id      | Order containing the item               |
| product_id    | Product included in the order           |
| quantity      | Quantity purchased                      |

---

## 4. Database Creation

The tables were created using PostgreSQL SQL syntax.

```sql
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
```

---

## 5. Data Population

The database was populated according to the assignment requirements:

* At least **5 customers**
* At least **8 products**
* Products from at least **3 categories**
* At least **15 orders**
* At least **25 order items**
* Orders distributed across **multiple dates**

The data represents realistic supermarket transactions and allows meaningful analysis using SQL.

---

# 6. JOIN Queries

## JOIN Query 1 — Orders and Customers

### Objective

List every order together with the customer's name, city, and order date.

### SQL Query

```sql
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;
```

### Explanation

This query uses an **INNER JOIN** between the `orders` and `customers` tables.

The tables are connected using `customer_id`. The query retrieves the order ID, customer's name, city, and date of the order.

An INNER JOIN returns only orders that have a matching customer.

### Result

**Screenshot of query result:**

> <img width="953" height="303" alt="Screenshot 2026-09-15 123211" src="https://github.com/user-attachments/assets/17c03940-bbda-45d6-99fc-b5e09bd3dedd" />



---

## JOIN Query 2 — Order Items and Products

### Objective

List every order item with the product name, category, price, and quantity purchased.

### SQL Query

```sql
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
```

### Explanation

This query joins `order_items` with `products` using `product_id`.

The `order_items` table contains the quantity purchased, while the `products` table contains the product name, category, and price.

The JOIN combines this information so that each order item can be understood in terms of the actual product purchased.

### Result

**Screenshot of query result:**

> <img width="943" height="428" alt="Screenshot 2026-09-15 123337" src="https://github.com/user-attachments/assets/94455955-c66f-48ff-bc57-52c109241f28" />


---

## JOIN Query 3 — Customers and Orders

### Objective

List all customers and their orders where they exist, including customers who have no orders.

### SQL Query

```sql
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
```

### Explanation

This query uses a **LEFT JOIN**.

The `customers` table is on the left side of the JOIN, so every customer is included in the result.

If a customer has an order, the order information is displayed. If a customer has no orders, the order columns contain `NULL`.

This helps management identify both active customers and customers who have not placed any orders.

### Result

**Screenshot of query result:**

> 






---

# 7. CTE Query

## CTE Query 1 — Customers Above Average Spending

### Objective

Calculate each customer's total spending and return customers whose spending is above the average customer spending.

### SQL Query

```sql
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
```

### Explanation

A **CTE (Common Table Expression)** is created using the `WITH` keyword.

The `customer_totals` CTE calculates the total amount spent by each customer using:

**Quantity × Product Price**

The main query then calculates the average customer spending and returns only customers whose total spending is greater than the average.

Using a CTE makes the query easier to organize because the customer totals are calculated first and then used in the main query.

### Result

**Screenshot of query result:**

> 



---

# 8. Window-Function Queries

## Window Query 1 — Rank Customers by Total Spending

### Objective

Rank customers according to the total amount they have spent, with the highest spender ranked first.

### SQL Query

```sql
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
```

### Explanation

The `RANK()` window function assigns a ranking to each customer based on their total spending.

The customer with the highest total spending receives rank **1**.

If two customers have the same total spending, they receive the same rank.

### Result

**Screenshot of query result:**

> Insert screenshot here.

---

## Window Query 2 — Number Each Customer's Orders

### Objective

Number each customer's orders according to the order date.

### SQL Query

```sql
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
```

### Explanation

The `ROW_NUMBER()` window function assigns a sequential number to each order.

`PARTITION BY customer_id` means that the numbering starts again for every customer.

For example:

* First order → 1
* Second order → 2
* Third order → 3

The orders are numbered according to their order date.

### Result

**Screenshot of query result:**

> Insert screenshot here.

---

## Window Query 3 — Running Total of Revenue

### Objective

Show a running total of revenue over time, ordered by order date.

### SQL Query

```sql
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
```

### Explanation

The query first calculates the revenue for each date using:

**Quantity × Product Price**

The `SUM() OVER()` window function then calculates the running total of revenue.

The running total shows how much revenue the supermarket has generated up to each date.

This helps management understand sales performance over time.

### Result

**Screenshot of query result:**

> Insert screenshot here.

---

## Window Query 4 — Days Between Customer Orders

### Objective

For each customer with more than one order, show the number of days between the current and previous order.

### SQL Query

```sql
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
```

### Explanation

The `LAG()` window function retrieves the previous order date for each customer.

The current order date is subtracted from the previous order date to determine the number of days between orders.

`PARTITION BY customer_id` ensures that each customer's orders are compared only with their own previous orders.

The first order for each customer has no previous order, so its `days_between_orders` value is `NULL`.

This helps management understand how frequently customers return to the supermarket.

### Result

**Screenshot of query result:**

> Insert screenshot here.

---

# 9. Business Interpretation

The SQL analysis provides useful information for Sunrise Supermarket management.

### Customer Spending

The customer spending analysis identifies customers who spend more than the average. These customers may be considered valuable customers and could be targeted with loyalty programs, discounts, or special offers.

### Customer Ranking

Ranking customers by total spending helps management identify the highest-value customers and develop customer retention strategies.

### Customer Orders

Numbering orders for each customer shows how frequently customers return to the supermarket. Customers with many orders may be regular customers.

### Revenue Trends

The running revenue analysis shows how sales accumulate over time. Management can use this information to identify periods of higher or lower sales and make better inventory and marketing decisions.

### Purchasing Frequency

The number of days between orders provides information about customer purchasing habits. Customers who return frequently may be regular shoppers, while customers with long gaps between orders may benefit from targeted promotions.

### Customers Without Orders

The LEFT JOIN query identifies customers who are registered in the system but have not placed any orders. Management could target these customers with promotions to encourage their first purchase.

---

# 10. Challenges and Resolutions

## Challenge 1 — Understanding JOINs

One challenge was understanding how different tables should be connected.

### Resolution

The relationships between primary keys and foreign keys were examined before writing the JOIN queries. For example, `customer_id` connects customers to orders, while `product_id` connects products to order items.

---

## Challenge 2 — Calculating Customer Spending

Calculating total spending required combining information from multiple tables.

### Resolution

The `orders`, `order_items`, and `products` tables were joined, and total spending was calculated using:

**Quantity × Price**

The results were grouped by customer.

---

## Challenge 3 — Understanding CTEs

The CTE query was challenging because it required calculating customer totals before comparing them with the average.

### Resolution

A CTE named `customer_totals` was created using the `WITH` clause. It calculated each customer's total spending first. The main query then used these totals to find customers above the average.

---

## Challenge 4 — Understanding Window Functions

Window functions such as `RANK()`, `ROW_NUMBER()`, `SUM() OVER()`, and `LAG()` were initially challenging.

### Resolution

Each function was tested separately:

* `RANK()` was used to rank customers.
* `ROW_NUMBER()` was used to number orders.
* `SUM() OVER()` was used to calculate running revenue.
* `LAG()` was used to access the previous order date.

This made it easier to understand how each window function works.

---

# 11. How to Run the Project

### Step 1 — Install PostgreSQL

Install PostgreSQL and either **pgAdmin 4** or use the **psql** command-line tool.

### Step 2 — Create a Database

Create a database for the assignment, for example:

```sql
CREATE DATABASE sunrise_supermarket;
```

Connect to the database before running the remaining SQL commands.

### Step 3 — Create the Tables

Run the table creation SQL statements provided in this README.

### Step 4 — Insert the Data

Insert at least:

* 5 customers
* 8 products
* 3 product categories
* 15 orders
* 25 order items
* Orders across multiple dates

### Step 5 — Run the Queries

Run each JOIN, CTE, and window-function query in PostgreSQL.

### Step 6 — View the Results

Check the output of each query and take screenshots of the results.

The screenshots should be included in this README to demonstrate that the queries were successfully executed.

---

# 12. Project Structure

The GitHub repository contains the SQL scripts and documentation for the assignment.

```text
assignment_1_channel-uwase-YOUR_STUDENT_ID/
│
├── README.md
└── assignment_1.sql
```

Where:

* `README.md` contains the project documentation, explanations, business interpretation, and results.
* `assignment_1.sql` contains the table creation, data insertion, and SQL queries.

---

# 13. Conclusion

This assignment demonstrates how SQL can be used to analyze business data for Sunrise Supermarket.

JOINs were used to combine related information from different tables. A CTE was used to calculate and analyze customer spending, while window functions were used to rank customers, number orders, calculate running revenue, and analyze the time between orders.

The analysis can help Sunrise Supermarket make better decisions about customer relationships, sales performance, purchasing behavior, and marketing strategies.

---

## Author

**Name:** Channel Uwase
**Student ID:** 20251SEN130
**DBMS:** PostgreSQL
**Project:** Assignment 1 — Sunrise Supermarket

