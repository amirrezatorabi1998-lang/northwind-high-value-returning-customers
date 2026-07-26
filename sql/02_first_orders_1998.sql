/*
Purpose:
- Find each customer's first order in 1998
*/

WITH orders_1998 AS (
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
)
SELECT
    CustomerID,
    OrderID AS first_order_id_1998,
    OrderDate AS first_order_date_1998
FROM orders_1998
WHERE rn = 1
ORDER BY first_order_date_1998, CustomerID;
