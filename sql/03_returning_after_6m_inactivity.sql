/*
Purpose:
- Identify customers who returned in 1998 after at least 6 months without any purchases
*/

WITH first_orders_1998 AS (
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
previous_orders AS (
    SELECT
        sfo.CustomerID,
        MAX(o.OrderDate) AS last_order_before_1998_first_order
    FROM selected_first_orders sfo
    LEFT JOIN Orders o
        ON o.CustomerID = sfo.CustomerID
       AND o.OrderDate < sfo.first_order_date_1998
    GROUP BY sfo.CustomerID
)
SELECT
    sfo.CustomerID,
    sfo.first_order_id_1998,
    sfo.first_order_date_1998,
    po.last_order_before_1998_first_order,
    DATEDIFF(DAY, po.last_order_before_1998_first_order, sfo.first_order_date_1998) AS days_since_last_order
FROM selected_first_orders sfo
LEFT JOIN previous_orders po
    ON sfo.CustomerID = po.CustomerID
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = sfo.CustomerID
      AND o.OrderDate < sfo.first_order_date_1998
      AND o.OrderDate >= DATEADD(MONTH, -6, sfo.first_order_date_1998)
)
ORDER BY sfo.first_order_date_1998, sfo.CustomerID;
