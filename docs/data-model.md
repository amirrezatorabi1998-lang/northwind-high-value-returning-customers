# Data Model Notes

This project uses the Northwind sample database and focuses on customer purchase behavior, returning-customer analysis, and product-category preferences across 1997 and 1998.

## Core Tables

### Customers
Contains customer-level information such as:
- `CustomerID`
- `CompanyName`
- `Country`

### Orders
Contains order-level information such as:
- `OrderID`
- `CustomerID`
- `OrderDate`
- `ShipCountry`

### [Order Details]
Contains line-item details for each order:
- `OrderID`
- `ProductID`
- `UnitPrice`
- `Quantity`
- `Discount`

### Products
Maps each product to a product category:
- `ProductID`
- `ProductName`
- `CategoryID`

### Categories
Provides category names:
- `CategoryID`
- `CategoryName`

## Analytical Entities

In addition to the base tables, the project uses several derived analytical entities:

### Returning Customers Cohort
A customer is considered part of the returning cohort if they:
- placed at least one order in 1998
- had no orders in the 6 months before their first 1998 order

This cohort is the basis for the comeback, engagement, and category-preference analysis.

### High-Value Legacy Flag
The original project logic included very strict high-value thresholds.  
Because those thresholds produced no qualifying returning customers in the Northwind dataset, the final category analysis keeps a legacy indicator to document that original business rule.

This flag is retained for traceability and documentation, but it is not used to exclude the returning cohort from Query 7.

### Customer Segments
For benchmarking in Query 8, customers are grouped into:
- `Returning`
- `Standard (Non-Returning)`

This allows category-level comparison between returning customers and the rest of the customer base.

## Grain

The project uses multiple grains:

- **customer grain** for return classification, country benchmarking, and cohort membership
- **order grain** for first-order analysis, comeback strength, and post-return engagement
- **order-line grain** for revenue calculation
- **customer-category grain** for Query 7 returning-customer preference analysis
- **segment-category grain** for Query 8 returning vs standard benchmarking

## Join Path

The main analytical joins are:

- `Customers` -> `Orders` via `CustomerID`
- `Orders` -> `[Order Details]` via `OrderID`
- `[Order Details]` -> `Products` via `ProductID`
- `Products` -> `Categories` via `CategoryID`

These joins allow the analysis to move from customer behavior to order value and then to category-level preferences.

## Revenue Logic

Revenue is calculated from order lines as:
```sql
SUM(UnitPrice * Quantity * (1 - Discount))
