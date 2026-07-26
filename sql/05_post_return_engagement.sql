/*
Purpose:
- Count additional orders after the customer's comeback order in 1998
- Classify engagement after return
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
    rc.first_order_id_1998,
    rc.first_order_date_1998,
    COUNT(o.OrderID) AS follow_up_orders_1998,
    CASE
        WHEN COUNT(o.OrderID) >= 2 THEN 'Sustained Re-engagement'
        WHEN COUNT(o.OrderID) = 1 THEN 'Limited Re-engagement'
        ELSE 'One-time Comeback'
    END AS engagement_type
FROM returning_customers rc
LEFT JOIN Orders o
    ON o.CustomerID = rc.CustomerID
   AND YEAR(o.OrderDate) = 1998
   AND (
        o.OrderDate > rc.first_order_date_1998
        OR (o.OrderDate = rc.first_order_date_1998 AND o.OrderID > rc.first_order_id_1998)
   )
GROUP BY
    rc.CustomerID,
    rc.first_order_id_1998,
    rc.first_order_date_1998
ORDER BY follow_up_orders_1998 DESC, rc.CustomerID;
