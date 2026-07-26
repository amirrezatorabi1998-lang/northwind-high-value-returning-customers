# Northwind High-Value Returning Customers Analysis

Identifying which customers came back in 1998 after a long inactive period, and whether those comebacks were genuinely valuable to the business.

[![View Report](https://img.shields.io/badge/View-Live%20Report-E4A24D?style=for-the-badge)](https://amirrezatorabi1998-lang.github.io/northwind-high-value-returning-customers/)

## 📊 [View Live Report](https://amirrezatorabi1998-lang.github.io/northwind-high-value-returning-customers/)

## Overview

This project analyzes the Northwind sample database to identify customers who returned in 1998 after at least 6 months of inactivity and to evaluate the quality of those returns.

The goal is not just to find customers who placed another order, but to distinguish between:
- Customers who made a one-time comeback purchase
- Customers whose return was commercially meaningful (Sustained Loyalty)

To do that, the analysis evaluates comeback strength, post-return engagement, country-level peer performance, and product/category patterns associated with returning customers.

---

## Main Business Question

Which customers re-engaged in 1998 after at least 6 months of inactivity, and which of those customers generated above-average business value after returning?

## Why This Question Matters

A returning customer is not always a valuable customer. Some customers come back once and disappear again, while others return with strong orders and remain active afterward.

This project focuses on identifying the difference between those two behaviors. In a real business setting, that distinction could support:
- Reactivation campaign targeting
- Customer segmentation
- Category-level promotion planning
- Early identification of high-potential returning customers

---

## Definition of a High-Value Returning Customer

For this project, a customer is classified as a **High-Value Returning Customer** if they meet the following baseline conditions:
1. The customer placed at least one order in 1998
2. The customer had no orders in the 6 months before their first 1998 order
3. The value of that first 1998 comeback order is above the average value of first 1998 orders across customers
4. The customer placed at least 2 additional orders later in 1998
5. The customer’s total 1998 sales are above the average total sales of customers from the same country

The High-Value definition is used for customer qualification in the early analytical stages, while the final category analysis focuses on the complete returning-customer cohort because the strict financial thresholds produced no qualifying records.

### ⚠️ Analytical Agility & Business Pivot (Query 7 & 8)
When applying highly strict financial thresholds for the final segment (e.g., Total Lifetime Spent > $10,000 or Average Order Value > $1,500), the dataset yielded zero (0) returning customers due to the small size and distribution of the Northwind database.

Rather than halting the analysis at a research dead-end, an analytical pivot was executed:
- We adjusted the final category preference analysis (Query 7) to include the full returning-customer cohort (13 customers) identified using the project’s returning-customer definition
- We maintained a legacy flag (`Is_High_Value_Legacy = 0`) to document the strict criteria while still analyzing the cohort’s product habits
- Query 8 benchmarks the purchasing behavior of the returning-customer cohort against the standard customer base

---

## Analysis Questions

### Step 0 — Scope and Baseline
What does customer activity in 1998 look like overall?

### Q1 — Returning Customers After Inactivity
Which customers placed orders in 1998 after at least 6 months without any purchases?

### Q2 — Comeback Order Strength
Was the first comeback order stronger than the average first order placed in 1998?

### Q3 — Sustained Engagement
Did these customers remain active after returning, or was the comeback only temporary?

### Q4 — Country-Level Benchmark
Did these customers outperform the average 1998 customer from their own country?

### Q5 — Product and Category Patterns
Which products and categories were most associated with the returning-customer cohort?

### Q6 — Detailed Returning Category Preferences (Query 7)
Evaluates category-level revenue and item quantity for the 13 returning customers, keeping a legacy flag for documentation.

### Q7 — Segment Benchmarking (Query 8)
Contrasts product category performance and average order contributions between the Returning cohort and Standard customer segments.

---

## Data Model

The analysis uses the core transactional tables in Northwind:
- `Customers`
- `Orders`
- `[Order Details]`
- `Products`
- `Categories`

A few modeling decisions are important:
- Customer behavior is tracked at the `CustomerID` level
- Order-level revenue is aggregated from `[Order Details]`
- Order value is calculated as:
```sql
SUM(UnitPrice * Quantity * (1 - Discount))