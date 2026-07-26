# Methodology

This project breaks the business question into a structured sequence of SQL analysis steps, moving from broad 1998 customer activity toward a focused behavioral analysis of returning customers.

The methodology is designed to answer not only **who returned**, but also **whether those returns were commercially meaningful** in terms of comeback strength, continued engagement, peer-level performance, and purchasing behavior.

---

## Step 0 — Scope and Baseline

The analysis begins by establishing the overall 1998 business baseline.  
This provides the reference point for all later comparisons.

Key metrics include:
- Active customers
- Total orders
- Total revenue
- Average order value (AOV)

This step helps define what “normal” customer activity looked like in 1998 before isolating the returning-customer cohort.

---

## Step 1 — First Orders in 1998

The next step identifies each customer’s **first order in 1998**.

This is essential because return behavior is defined relative to the customer’s first observed purchase in the 1998 period.  
Without identifying that first order, it would not be possible to determine whether the customer had been inactive beforehand.

---

## Step 2 — Returning After 6 Months of Inactivity

A customer is classified as a **Returning Customer** if:

- they placed at least one order in 1998
- they had no orders in the 6 months prior to their first 1998 order

This rule defines the project’s core behavioral cohort.

Using this definition, the analysis identifies **13 unique returning customers**.

This cohort becomes the foundation for all later stages of the project, including comeback analysis, engagement tracking, benchmarking, and category preference evaluation.

---

## Step 3 — Comeback Order Strength

After identifying the returning customers, the analysis measures the value of each customer’s **first 1998 comeback order**.

That comeback order value is then compared against the **average first-order value across all customers in 1998**.

This step helps distinguish:
- weaker comeback behavior
- average re-entry behavior
- stronger-than-baseline comeback orders

The purpose is to evaluate whether returning customers came back with meaningful commercial intent or only with small re-entry purchases.

---

## Step 4 — Post-Return Engagement

Return behavior is not evaluated only by the first comeback order.

This step measures what happened **after** the customer returned by counting how many additional orders each returning customer placed later in 1998.

This allows the analysis to separate:
- one-time comeback customers
- lightly re-engaged customers
- sustainably reactivated customers

This stage is especially important because the strongest business signal in reactivation analysis is often not the first purchase itself, but whether the customer continues ordering afterward.

---

## Step 5 — Country-Level Benchmark

The next stage evaluates returning customers in a more contextual way by comparing their total 1998 sales with the average customer sales of their own country.

For each returning customer, the analysis calculates:
- total 1998 sales
- average 1998 sales for customers from the same country

This creates a country-level benchmark that helps control for regional differences in market behavior.

Instead of asking only whether a returning customer spent “a lot” in absolute terms, this step asks whether the customer performed **above local expectations**.

---

## Methodological Pivot — Managing Data Sparsity

The original business framing of the project aimed to isolate a narrower set of **High-Value Returning Customers** using strict financial filters.

However, when those conditions were applied to the Northwind dataset, the result was **zero qualifying records** within the returning-customer cohort.

Rather than ending the project with a zero-row output, the methodology was intentionally adjusted in order to preserve analytical value while remaining faithful to the observed data.

The pivot involved three decisions:

- the behavioral definition of the returning-customer cohort was preserved
- the final product/category analysis was expanded to include the full returning-customer cohort
- a legacy high-value indicator was retained only for traceability and documentation

This adjustment keeps the project analytically honest.  
It also reflects a realistic business practice: when strict thresholds eliminate all usable observations, the analysis should be reframed around the strongest defensible cohort rather than forced into an empty conclusion.

---

## Step 6 — Category Patterns for Returning Customers

Once the full returning-customer cohort is confirmed, the analysis shifts from customer qualification to **behavioral interpretation**.

This step examines which product categories are most associated with the returning-customer cohort.

The analysis focuses on:
- category-level revenue
- purchased quantity
- customer-category participation patterns

The objective is to identify where returning customers concentrated their buying behavior after reactivation.

This helps answer whether returning customers tend to re-engage through specific types of products rather than through the catalog in general.

---

## Step 7 — Segment Benchmarking

The final analytical step compares category purchasing behavior between two segments:

- `Returning`
- `Standard (Non-Returning)`

This comparison is performed to identify whether returning customers behave differently from the broader customer base.

The benchmarking focuses on differences in:
- category revenue
- customer participation
- order participation
- purchasing concentration by category

This step makes it possible to determine whether the returning-customer cohort shows stronger alignment with specific categories, more focused buying behavior, or a different purchasing mix than standard customers.

---

## Final Output

The final interpretation of the project is designed to answer the following questions:

- How many customers returned after at least 6 months of inactivity?
- How many of those customers placed above-average comeback orders?
- How many remained active after returning?
- How many outperformed the average customer in their own country?
- Which product categories were most associated with the returning-customer cohort?
- How does the category behavior of returning customers differ from the standard customer base?

---

## Methodology Summary

In summary, the project follows a progression from:
1. overall 1998 customer activity
2. first-order identification
3. return classification
4. comeback quality measurement
5. sustained engagement analysis
6. country-level benchmarking
7. category-level behavioral interpretation
8. segment comparison

This structure ensures that the final product and category insights are grounded in a clearly defined and consistently applied returning-customer cohort.
