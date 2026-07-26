/*
Purpose:
- Calculate comeback order value
- Compare it with the average value of first 1998 orders across customers
*/

WITH order_values AS (
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
),
first_orders_1998 AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
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
        OrderID AS first_order_id_1998,
        OrderDate AS first_order_date_1998
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
),
first_order_benchmark AS (
    SELECT
        CAST(AVG(ov.order_value) AS DECIMAL(18, 2)) AS avg_first_order_value_1998
    FROM selected_first_orders sfo
    JOIN order_values ov
        ON sfo.first_order_id_1998 = ov.OrderID
)
SELECT
    rc.CustomerID,
    rc.first_order_id_1998,
    rc.first_order_date_1998,
    ov.order_value AS comeback_order_value,
    fob.avg_first_order_value_1998,
    CASE
        WHEN ov.order_value > fob.avg_first_order_value_1998 THEN 1
        ELSE 0
    END AS is_above_avg_first_order_value
FROM returning_customers rc
JOIN order_values ov
    ON rc.first_order_id_1998 = ov.OrderID
CROSS JOIN first_order_benchmark fob
ORDER BY ov.order_value DESC, rc.CustomerID;
