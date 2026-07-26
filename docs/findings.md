# Analytical Findings & Business Insights

This document summarizes the empirical findings from the SQL analysis executed on the Northwind dataset.

---

## 1. Executive Summary

- **Total Active Customers in 1998:** 81
- **Returning Customers (after 6+ months of inactivity):** 13
- **High-Value Returning Customers (Strict Legacy Criteria):** 0

*Note: Due to the strict financial thresholds (Total Spent > $10,000 OR Avg Order Value > $1,500), none of the 13 returning customers qualified. To ensure actionable insights, the analysis pivoted to evaluate the category preferences and behaviors of the entire cohort of 13 returning customers.*

---

## 2. Comeback Order Quality (Query 2 & 3)

- **Average First 1998 Order Value (Overall Baseline):** $1,619.67
- **Returning Customers Above the Benchmark:** 4 out of 13

*Key Insight:* Most returning customers re-engaged with lower-value trial orders, while a smaller subset immediately placed higher-value orders upon return.

---

## 3. Post-Return Engagement & Retention (Query 4)

Understanding whether the comeback was a one-time event or led to sustained loyalty:

- **0 Follow-up Orders (One-time buyers):** 1 customer (approx. 7.7%)
- **1 Follow-up Order:** 2 customers (approx. 15.4%)
- **2+ Follow-up Orders (Sustained Engagement):** 10 customers (approx. 76.9%)

*Key Insight:* Retention quality is exceptionally high. Over 76% of inactive customers who returned went on to place multiple orders, demonstrating genuine re-engagement.

---

## 4. Country Benchmarks (Query 5)

Comparing returning customers against their local peers to control for regional market sizes:

- **Returning Customers Outperforming Country Average:** 5 out of 13
- **Top Countries Represented by Returning Cohort:**
  1. Germany (3 customers)
  2. Brazil (2 customers)
  3. USA (2 customers)

---

## 5. Product Category Preferences (Query 7 & 8)

By analyzing the purchase patterns of the 13 returning customers, we mapped their revenue distribution:

- **Most Preferred Product Category:** **Beverages**
- **Secondary Core Categories:** **Dairy Products** and **Confections**
- **Category Behavior vs. Standard Base (Segment Comparison):**
  - Returning customers show a stronger concentration of purchasing activity in **Beverages** and **Dairy Products**
  - Standard customers showed more fragmented purchasing habits across categories

*Insight:* Returning customers appear to concentrate more heavily in repeat-friendly food and beverage lines, which suggests these categories play an important role in customer reactivation.

---

## 6. Business Interpretation

The data indicates that while returning customers do not immediately qualify as "High-Value" accounts under strict individual financial definitions, they represent a highly valuable behavioral segment.

With a **76.9% sustained engagement rate** (2+ follow-up orders) post-comeback, reactivating inactive accounts appears to be highly efficient.

The category pattern also suggests that reactivation campaigns should emphasize staple, repeat-purchase categories such as **Beverages** and **Dairy Products**, rather than focusing only on one-time large transactions.

### Final Takeaway
The strongest business signal is not just whether customers return, but whether they continue purchasing afterward. In this dataset, sustained re-engagement is the clearest indicator of commercial value.
