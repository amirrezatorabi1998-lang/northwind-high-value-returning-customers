/* 
Purpose:
- Establish 1998 activity baseline
- Count active customers, orders, revenue, and average order value
*/

WITH order_values_1998 AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        o.OrderDate,
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18, 2)) AS order_value
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY
        o.OrderID,
        o.CustomerID,
        o.OrderDate
)
SELECT
    COUNT(DISTINCT CustomerID) AS active_customers_1998,
    COUNT(*) AS total_orders_1998,
    CAST(SUM(order_value) AS DECIMAL(18, 2)) AS total_revenue_1998,
    CAST(AVG(order_value) AS DECIMAL(18, 2)) AS avg_order_value_1998
FROM order_values_1998;


/* Optional supporting breakdown: active customers and revenue by country */
WITH order_values_1998 AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        c.Country,
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18, 2)) AS order_value
    FROM Orders o
    JOIN Customers c
        ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY
        o.OrderID,
        o.CustomerID,
        c.Country
)
SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS active_customers,
    COUNT(*) AS total_orders,
    CAST(SUM(order_value) AS DECIMAL(18, 2)) AS total_revenue
FROM order_values_1998
GROUP BY Country
ORDER BY total_revenue DESC;
