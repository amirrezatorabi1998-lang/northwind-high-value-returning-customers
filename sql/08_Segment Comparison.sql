-- =================================================================================
-- Query 8: Behavioral Comparison Between Returning and Standard Customers
-- ---------------------------------------------------------------------------------
-- Definition of Returning Customer (aligned with Query 3):
--   1) Customer placed at least one order in 1998
--   2) We identify the first order in 1998
--   3) Customer had no purchases in the 6 months prior to that first 1998 order
--
-- Business purpose:
--   Compare 1998 category-level purchasing behavior between:
--     - Returning customers
--     - Standard (Non-Returning) customers
-- =================================================================================

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
    WHERE o.OrderDate >= '1998-01-01'
      AND o.OrderDate < '1999-01-01'
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
        sfo.CustomerID
    FROM selected_first_orders sfo
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o
        WHERE o.CustomerID = sfo.CustomerID
          AND o.OrderDate < sfo.first_order_date_1998
          AND o.OrderDate >= DATEADD(MONTH, -6, sfo.first_order_date_1998)
    )
),

category_activity_1998 AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        CASE
            WHEN rc.CustomerID IS NOT NULL THEN 'Returning'
            ELSE 'Standard (Non-Returning)'
        END AS Customer_Segment,
        cat.CategoryName,
        od.Quantity,
        CAST(od.UnitPrice * od.Quantity * (1 - od.Discount) AS DECIMAL(18,2)) AS Net_Revenue
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    JOIN Categories cat
        ON p.CategoryID = cat.CategoryID
    LEFT JOIN returning_customers rc
        ON o.CustomerID = rc.CustomerID
    WHERE o.OrderDate >= '1998-01-01'
      AND o.OrderDate < '1999-01-01'
)

SELECT
    Customer_Segment,
    CategoryName,
    COUNT(DISTINCT OrderID) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Distinct_Customers,
    SUM(Quantity) AS Total_Units_Sold,
    CAST(SUM(Net_Revenue) AS DECIMAL(18,2)) AS Segment_Revenue,
    CAST(
        SUM(Net_Revenue) / NULLIF(COUNT(DISTINCT OrderID), 0)
        AS DECIMAL(18,2)
    ) AS Average_Order_Value_Contribution
FROM category_activity_1998
GROUP BY
    Customer_Segment,
    CategoryName
ORDER BY
    Customer_Segment,
    Segment_Revenue DESC,
    CategoryName;
