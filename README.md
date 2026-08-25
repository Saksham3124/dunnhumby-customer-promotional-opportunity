# Dunnhumby Customer & Promotional Opportunity Analysis

End-to-end customer segmentation, category performance analysis, and promotional opportunity diagnostics built on the **dunnhumby Complete Journey** dataset using Python, PostgreSQL, AWS S3/Athena, and Power BI.

The project identifies high-potential households that have strong behavioral and category affinity but no recorded campaign history, while independently validating the core analytical results across three analytical environments.

---

## Business Question

**Which product categories and customer segments should receive greater promotional investment, and where should promotional strategy be optimized?**

---

## Key Finding

**10 households** combine near-ceiling:

* **Engagement:** 99.17th percentile average
* **Category affinity:** 98.97th percentile average
* **Campaign history:** 0 recorded campaigns

This identifies a specific, behaviorally defined promotional opportunity rather than a broad customer segment.

Under an explicitly labeled **illustrative +10% sensitivity scenario**, targeting these households represents approximately **$18.1K in potential incremental sales**.

> **Important:** The $18.1K figure is not a causal forecast or evidence-based uplift estimate. It is a sensitivity case used to quantify the potential scale of the identified opportunity.

---

## Project Highlights

* Analyzed **2,500 households** and approximately **2.6M transactions**
* Covered **102 weeks** of customer purchase behavior
* Analyzed approximately **$8.06M in total sales**
* Built a household-level **Promotional Opportunity Score**
* Performed customer segmentation and category affinity analysis
* Translated the analytical pipeline from Python into PostgreSQL
* Independently validated core results using AWS Athena
* Built a three-page Power BI dashboard
* Developed a campaign sensitivity analysis
* Converted analytical findings into business recommendations
* Documented and corrected two methodological issues discovered during development

---

## Approach

```text
Pandas / EDA + Scoring & Segmentation
                ↓
PostgreSQL — Analytical Layer
                ↓
Pandas ↔ PostgreSQL Validation
                ↓
AWS S3 + Athena — Independent Validation
                ↓
Campaign Scenario — Sensitivity Analysis
                ↓
Power BI Dashboard — 3 Pages
                ↓
Recommendation Memo
```

Each stage has a distinct purpose:

* **Python** develops the analytical logic and scoring framework.
* **PostgreSQL** translates and independently re-confirms the analytical logic.
* **AWS S3 + Athena** validates core figures against raw cloud-hosted data.
* **Campaign Scenario** tests the potential scale of the identified opportunity.
* **Power BI** communicates the findings through an executive-facing dashboard.
* **Recommendation Memo** converts the analysis into business actions.

The workflow intentionally avoids re-deriving the same analysis unnecessarily at each stage.

---

# Methodology

## 1. Data Audit

The first notebook inventories and validates the dunnhumby Complete Journey dataset before analytical work begins.

Key dataset characteristics:

* **2,500 households**
* **2.6M transactions**
* **102 weeks**
* **$8.06M total sales**

Checks include:

* Schema validation
* Data quality checks
* Duplicate detection
* Referential integrity
* Time coverage
* Basic dataset consistency

---

## 2. EDA & Business Scoring

The analysis covers:

* Category performance
* Household behavior
* Campaign activity
* Customer demographics
* Household value segmentation
* Category affinity
* Promotional opportunity

A household-level **Promotional Opportunity Score** was developed using:

| Component               | Weight |
| ----------------------- | -----: |
| Engagement              |    35% |
| Category Affinity       |    30% |
| Campaign Responsiveness |    35% |

The score combines behavioral engagement, category specialization, and historical campaign responsiveness to identify households with potential promotional opportunity.

---

## 3. Analytical Challenges & Fixes

Two methodological issues were identified during development and corrected before the final results were produced.

### Zero-Inflation in Campaign Responsiveness

The initial scoring logic caused non-responding households to cluster around an artificial **41st percentile** rather than correctly occupying the bottom of the responsiveness distribution.

The scoring logic was revised so that households with zero recorded campaign response are appropriately represented at the bottom of the distribution.

### Department-Size Bias in Category Affinity

The initial affinity calculation allowed large departments such as **Grocery** to dominate household-level "top affinity" rankings because of department scale rather than genuine household specialization.

The methodology was revised to measure **relative household specialization** instead of allowing department size alone to determine affinity.

Both corrections were documented with before/after evidence and carried through to the PostgreSQL implementation.

---

## 4. PostgreSQL Validation

The full scoring pipeline was translated into PostgreSQL using:

* Common Table Expressions (CTEs)
* Window functions
* Aggregations
* Ranking logic

The PostgreSQL results were cross-validated against the pandas implementation.

Validated areas include:

* Total sales
* Department performance
* Household metrics
* Campaign metrics
* Segmentation
* Promotional opportunity scores

The results matched the pandas outputs to the cent.

---

## 5. AWS S3 + Athena

The raw CSV files were landed in **AWS S3** and queried using **Amazon Athena**.

Athena was used as a third analytical environment to independently re-confirm core figures from the raw cloud-hosted data.

This provided three-layer validation:

```text
Pandas
   ↕
PostgreSQL
   ↕
AWS Athena
```

Core totals and row counts were independently confirmed across the analytical environments.

---

## 6. Campaign Scenario

The campaign analysis examines whether historical campaign exposure is associated with higher spending.

The comparison was stratified by household value tier to account for differences in baseline customer value.

For the identified untapped households, their own value tier showed **no positive historical campaign-exposure gap**.

Therefore, the final **+10% uplift assumption is explicitly treated as an illustrative sensitivity case**, rather than an evidence-based forecast.

The scenario is intended to answer:

> **"What could the opportunity be worth under a defined sensitivity assumption?"**

It is not intended to answer:

> **"How much incremental sales will the campaign definitely generate?"**

---

# Key Findings

## Category Concentration

**GROCERY generates 50.81% of total sales.**

However, category reach and category value are not equivalent.

Some categories generate high sales from relatively few households, while others have broader household penetration at lower value per household.

This highlights why promotional decisions should not rely on total category sales alone.

---

## Customer Segment Concentration

**High Value – Frequent households represent 42.0% of the customer base but generate 76.36% of total sales.**

This demonstrates substantial revenue concentration within the highest-value behavioral segment.

Protecting and retaining this group is therefore an important part of promotional strategy.

---

## Untapped Household Opportunity

The most actionable finding is the identification of **10 households** that simultaneously exhibit:

* Extremely high engagement
* Extremely high category affinity
* Zero recorded campaign history

These households are not simply "high-value customers."

They represent a more specific opportunity:

> **Customers demonstrating strong behavioral and category signals without recorded campaign exposure.**

Under the illustrative +10% sensitivity scenario, these households represent approximately **$18.1K in potential incremental sales**.

---

# Business Recommendations

Based on the analysis:

### 1. Prioritize the 10 untapped households for testing

These households combine unusually strong behavioral signals with no recorded campaign history.

They should be considered candidates for a targeted promotional test.

### 2. Use category-specific targeting

Promotional strategy should account for individual household category affinity rather than relying solely on broad department-level targeting.

### 3. Protect the high-value customer base

High Value – Frequent households contribute a disproportionate share of revenue.

Retention and targeted promotional strategies should therefore remain an important priority.

### 4. Treat the $18.1K estimate as a sensitivity case

The estimated opportunity should not be presented as guaranteed incremental revenue.

A controlled campaign experiment should be used to measure actual incremental impact.

### 5. Replace the illustrative assumption with measured uplift

Future campaign results can provide empirical uplift estimates that replace the current +10% sensitivity assumption.

---

# Validation

Every core figure is cross-checked across:

**Python → PostgreSQL → AWS Athena**

Key validated metrics include:

| Metric                            |            Result |
| --------------------------------- | ----------------: |
| Total Sales                       | **$8,057,463.08** |
| Households                        |         **2,500** |
| Transaction Volume                |         **~2.6M** |
| Time Coverage                     |     **102 weeks** |
| GROCERY Share of Sales            |        **50.81%** |
| High Value – Frequent Sales Share |        **76.36%** |
| Untapped Households               |            **10** |

Validation logic and outputs are documented in the notebooks, particularly:

`03_postgresql_analysis.ipynb` — Section 3.5

---

# Power BI Dashboard

The Power BI dashboard consists of three pages:

### 1. Executive Overview

Provides a high-level view of:

* Overall sales
* Customer segments
* Category performance
* Key business findings

![Executive Overview](images/executive_overview.png)

### 2. Customer & Category Insights

Explores:

* Household behavior
* Customer segments
* Category performance
* Category reach and value
* Customer-level patterns

![Customer & Category Insights](images/customer_category_insights.png)

### 3. Promotional Opportunity Diagnostic

Provides a diagnostic view of the identified opportunity households, showing their score components side by side.

![Promotional Opportunity Diagnostic](images/promotional_opportunity.png)

> **Diagnostic note:** Scores represent relative standing among the 2,500 households. The projected uplift is an illustrative sensitivity case rather than an evidence-based forecast.

---

# Repository Structure

```text
├── Notebooks/
│   ├── 01_data_audit.ipynb
│   │   # Schema, quality checks, referential integrity
│   │
│   ├── 02_analytical_eda_v2_natural.ipynb
│   │   # EDA, business scoring, segmentation
│   │
│   ├── 03_postgresql_analysis.ipynb
│   │   # SQL translation + pandas/PostgreSQL validation
│   │
│   └── 04_campaign_scenario.ipynb
│       # Campaign scenario sensitivity analysis
│
├── sql/
│   └── # Standalone PostgreSQL analytical queries
│
├── aws/
│   └── # S3/Athena setup and validation queries
│
├── PowerBI/
│   └── # Three-page Power BI dashboard
│
├── memo/
│   └── # Recommendation memo
│
├── data/
│   └── Derived/
│       # Exported summary tables feeding Power BI
│
├── images/
│   ├── executive_overview.png
│   ├── customer_category_insights.png
│   └── promotional_opportunity.png
│
└── README.md
```

---

# Reproducibility

The analysis is organized as a sequential workflow:

```text
01_data_audit.ipynb
        ↓
02_analytical_eda_v2_natural.ipynb
        ↓
03_postgresql_analysis.ipynb
        ↓
04_campaign_scenario.ipynb
        ↓
Derived Outputs
        ↓
Power BI Dashboard
        ↓
Recommendation Memo
```

### Suggested execution order

1. Run `01_data_audit.ipynb`
2. Run `02_analytical_eda_v2_natural.ipynb`
3. Run `03_postgresql_analysis.ipynb`
4. Run `04_campaign_scenario.ipynb`
5. Review the exported tables in `data/Derived/`
6. Open the Power BI dashboard in `PowerBI/`
7. Review the recommendation memo in `memo/`

The raw dataset is not included in this repository. The notebooks require the source data to be available locally before execution.

---

# Limitations & Assumptions

* The campaign scenario's **+10% uplift is an illustrative sensitivity case**, not a causal estimate.
* The untapped households' own value tier showed **no positive historical campaign-exposure gap**.
* The exposed-vs-non-exposed comparison is a **stratified observational comparison**, not a randomized experiment.
* Historical association between campaign exposure and spending should therefore not be interpreted as causal impact.
* Demographic data covers only **32% of households** and is treated as supplementary context rather than primary segmentation.
* The dataset's `quantity` field mixes item counts and weight-based units depending on product type. Category-level quantity comparisons are therefore **directional rather than literal unit counts**.
* The $18.1K opportunity estimate depends on the illustrative +10% sensitivity assumption and should be validated through controlled experimentation.

---

# Tech Stack

```text
Python
├── pandas
├── NumPy
├── Matplotlib
└── psycopg2

SQL
├── PostgreSQL
├── CTEs
└── Window Functions

AWS
├── Amazon S3
└── Amazon Athena

Business Intelligence
└── Microsoft Power BI
```

---

# What This Project Demonstrates

* End-to-end customer and promotional analytics
* Exploratory data analysis
* Customer segmentation
* Behavioral scoring
* Category affinity analysis
* Promotional opportunity identification
* SQL analytical development
* Python-to-SQL translation
* Cross-platform analytical validation
* AWS S3 and Athena data analysis
* Power BI dashboard development
* Business-focused data storytelling
* Translating analytical findings into recommendations
* Identifying and correcting analytical methodology issues
* Explicit treatment of assumptions and limitations
* Distinguishing observational analysis from causal inference
* Communicating uncertainty around business estimates

---

# Project Deliverables

| Deliverable         | Purpose                                                   |
| ------------------- | --------------------------------------------------------- |
| Python Notebooks    | Data audit, EDA, scoring, segmentation, scenario analysis |
| PostgreSQL Analysis | SQL translation and analytical validation                 |
| AWS S3 + Athena     | Independent cloud-based validation                        |
| Power BI Dashboard  | Interactive business visualization                        |
| Recommendation Memo | Executive interpretation and actions                      |
| Derived Data        | Tables supporting dashboard outputs                       |
| README              | Project methodology, findings, and reproducibility        |

---

# Final Takeaway

The analysis identifies a specific promotional opportunity rather than simply ranking customers by historical value.

**10 households demonstrate extremely high engagement and category affinity while having zero recorded campaign history.**

This creates a focused candidate pool for promotional testing.

The project deliberately separates:

**what the historical data demonstrates**

from

**what a hypothetical campaign scenario assumes.**

The result is a validated analytical workflow that moves from raw customer transactions to **segmentation, opportunity identification, independent validation, dashboard communication, and actionable business recommendations**.
