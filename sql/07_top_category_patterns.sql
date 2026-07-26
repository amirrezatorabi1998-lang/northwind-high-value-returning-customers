-- =================================================================================
-- Query 7: Product Category Preferences for Returning Customers
-- ---------------------------------------------------------------------------------
-- Definition of Returning Customer (aligned with Query 3):
--   1) Customer placed at least one order in 1998
--   2) We identify the first order in 1998
--   3) Customer had no purchases in the 6 months prior to that first 1998 order
--
-- Business purpose:
--   Analyze 1998 category purchase behavior for the returning-customer cohort.
--
-- Note:
--   The legacy high-value flag is retained only for documentation/comparison
--   purposes and is not used to define the final analytical cohort.
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

order_values AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,2)) AS order_value
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.OrderID,
        o.CustomerID
),

customer_sales_profile AS (
    SELECT
        rc.CustomerID,
        COUNT(ov.OrderID) AS total_orders,
        CAST(SUM(ov.order_value) AS DECIMAL(18,2)) AS total_sales,
        CAST(AVG(ov.order_value) AS DECIMAL(18,2)) AS avg_order_value
    FROM returning_customers rc
    JOIN order_values ov
        ON rc.CustomerID = ov.CustomerID
    GROUP BY rc.CustomerID
),

category_purchases_1998 AS (
    SELECT
        rc.CustomerID,
        c.CompanyName,
        cat.CategoryName,
        SUM(od.Quantity) AS category_quantity_bought,
        CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,2)) AS category_revenue
    FROM returning_customers rc
    JOIN Customers c
        ON rc.CustomerID = c.CustomerID
    JOIN Orders o
        ON rc.CustomerID = o.CustomerID
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    JOIN Products p
        ON od.ProductID = p.ProductID
    JOIN Categories cat
        ON p.CategoryID = cat.CategoryID
    WHERE o.OrderDate >= '1998-01-01'
      AND o.OrderDate < '1999-01-01'
    GROUP BY
        rc.CustomerID,
        c.CompanyName,
        cat.CategoryName
)

SELECT
    cp.CustomerID,
    cp.CompanyName,
    cp.CategoryName,
    cp.category_quantity_bought,
    cp.category_revenue,
    CASE
        -- Legacy business rule retained for documentation only.
        -- In this project, it is not used to define the final returning cohort.
        WHEN csp.total_sales > 10000
          OR csp.avg_order_value > 1500
        THEN 1
        ELSE 0
    END AS Is_High_Value_Legacy
FROM category_purchases_1998 cp
JOIN customer_sales_profile csp
    ON cp.CustomerID = csp.CustomerID
ORDER BY
    cp.CustomerID,
    cp.category_revenue DESC,
    cp.CategoryName;
