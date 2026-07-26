/*
Purpose:
- Compare each returning customer's total 1998 sales against the average customer from the same country
*/

WITH order_values_1998 AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18, 2)) AS order_value
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY
        o.OrderID,
        o.CustomerID
),
customer_sales_1998 AS (
    SELECT
        ov.CustomerID,
        c.Country,
        CAST(SUM(ov.order_value) AS DECIMAL(18, 2)) AS total_sales_1998
    FROM order_values_1998 ov
    JOIN Customers c
        ON ov.CustomerID = c.CustomerID
    GROUP BY
        ov.CustomerID,
        c.Country
),
country_avg_sales AS (
    SELECT
        Country,
        CAST(AVG(total_sales_1998) AS DECIMAL(18, 2)) AS avg_country_sales_1998
    FROM customer_sales_1998
    GROUP BY Country
),
first_orders_1998 AS (
    SELECT
        o.CustomerID,
        o.OrderID AS first_order_id_1998,
        o.OrderDate AS first_order_date_1998,
        ROW_NUMBER() OVER (
            PARTITION BY o.CustomerID
            ORDER BY o.OrderDate, o.OrderID
        ) AS rn
    FROM Orders o
    WHERE YEAR(o.OrderDate) = 1998
),
selected_first_orders AS (
    SELECT
        CustomerID,
        first_order_id_1998,
        first_order_date_1998
    FROM first_orders_1998
    WHERE rn = 1
),
returning_customers AS (
    SELECT
        sfo.CustomerID,
        sfo.first_order_id_1998,
        sfo.first_order_date_1998
    FROM selected_first_orders sfo
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o
        WHERE o.CustomerID = sfo.CustomerID
          AND o.OrderDate < sfo.first_order_date_1998
          AND o.OrderDate >= DATEADD(MONTH, -6, sfo.first_order_date_1998)
    )
)
SELECT
    rc.CustomerID,
    cs.Country,
    cs.total_sales_1998,
    ca.avg_country_sales_1998,
    CASE
        WHEN cs.total_sales_1998 > ca.avg_country_sales_1998 THEN 1
        ELSE 0
    END AS is_above_country_avg
FROM returning_customers rc
JOIN customer_sales_1998 cs
    ON rc.CustomerID = cs.CustomerID
JOIN country_avg_sales ca
    ON cs.Country = ca.Country
ORDER BY cs.total_sales_1998 DESC, rc.CustomerID;
