-- PostgreSQL Analytical Queries
-- Source: 03_postgresql_analysis.ipynb
-- Consolidated from the final SQL used in the project.

-- 3.1 PostgreSQL Connection
SELECT datname
    FROM pg_database
    WHERE datistemplate = false;

-- 3.2 Database Setup
#     CREATE DATABASE promotional_analytics
#     WITH OWNER = postgres;
#

-- 3.3 Data Loading
CREATE TABLE IF NOT EXISTS transaction_data (
    household_key INTEGER,
    basket_id BIGINT,
    day INTEGER,
    product_id BIGINT,
    quantity INTEGER,
    sales_value NUMERIC(12,2),
    store_id INTEGER,
    retail_disc NUMERIC(12,2),
    trans_time INTEGER,
    week_no INTEGER,
    coupon_disc NUMERIC(12,2),
    coupon_match_disc NUMERIC(12,2)
);

-- 3.3 Data Loading
CREATE TABLE IF NOT EXISTS product (
    product_id BIGINT,
    manufacturer INTEGER,
    department VARCHAR(100),
    brand VARCHAR(100),
    commodity_desc VARCHAR(255),
    sub_commodity_desc VARCHAR(255),
    curr_size_of_product VARCHAR(100)
);

-- 3.3 Data Loading
SELECT
    (SELECT COUNT(*) FROM transaction_data) AS transaction_rows,
    (SELECT COUNT(*) FROM product) AS product_rows;

-- 3.3 Data Loading
SELECT
        COUNT(*) AS total_rows,
        COUNT(DISTINCT product_id) AS unique_products
    FROM product;

-- 3.3 Data Loading
CREATE TABLE IF NOT EXISTS campaign_table (
    description VARCHAR(100),
    household_key INTEGER,
    campaign INTEGER
);

CREATE TABLE IF NOT EXISTS coupon_redempt (
    household_key INTEGER,
    day INTEGER,
    coupon_upc BIGINT,
    campaign INTEGER
);

CREATE TABLE IF NOT EXISTS campaign_desc (
    description VARCHAR(100),
    campaign INTEGER,
    start_day INTEGER,
    end_day INTEGER
);

CREATE TABLE IF NOT EXISTS hh_demographic (
    classification_1 VARCHAR(100),
    classification_2 VARCHAR(100),
    classification_3 VARCHAR(100),
    homeowner_desc VARCHAR(100),
    classification_5 VARCHAR(100),
    classification_4 VARCHAR(100),
    kid_category_desc VARCHAR(100),
    household_key INTEGER
);

-- 3.4.1 Household Performance
SELECT
    household_key,
    SUM(sales_value) AS sales,
    COUNT(DISTINCT basket_id) AS transactions,
    SUM(quantity) AS quantity,
    ROUND(
        SUM(sales_value) / NULLIF(COUNT(DISTINCT basket_id), 0),
        2
    ) AS sales_per_transaction
FROM transaction_data
GROUP BY household_key
ORDER BY sales DESC;

-- 3.4.2 Department Performance
SELECT
    p.department,
    SUM(t.sales_value) AS sales,
    SUM(t.quantity) AS quantity,
    COUNT(DISTINCT t.basket_id) AS transactions,
    COUNT(DISTINCT t.household_key) AS households
FROM transaction_data t
JOIN product p
    ON t.product_id = p.product_id
GROUP BY p.department
ORDER BY sales DESC;

-- 3.4.2 Department Performance
SELECT SUM(sales_value) AS total_sales
FROM transaction_data;

-- 3.4.3 Campaign Performance
SELECT
    campaign,
    COUNT(DISTINCT household_key) AS households_targeted
FROM campaign_table
GROUP BY campaign
ORDER BY households_targeted DESC;

-- 3.4.3 Campaign Performance
SELECT
    campaign,
    COUNT(*) AS redemptions,
    COUNT(DISTINCT household_key) AS households_redeemed
FROM coupon_redempt
GROUP BY campaign
ORDER BY redemptions DESC;

-- 3.4.3 Campaign Performance
SELECT
    c.campaign,
    COUNT(DISTINCT c.household_key) AS households_targeted,
    COUNT(DISTINCT r.household_key) AS households_redeemed,
    ROUND(
        100.0 * COUNT(DISTINCT r.household_key)
        / NULLIF(COUNT(DISTINCT c.household_key), 0),
        2
    ) AS redemption_rate_pct
FROM campaign_table c
LEFT JOIN coupon_redempt r
    ON c.campaign = r.campaign
    AND c.household_key = r.household_key
GROUP BY c.campaign
ORDER BY redemption_rate_pct DESC;

-- 3.4.4 Campaign Sales Performance
SELECT
    c.campaign,
    COUNT(DISTINCT c.household_key) AS households_targeted,
    ROUND(SUM(t.sales_value), 2) AS total_sales,
    COUNT(DISTINCT t.basket_id) AS transactions
FROM campaign_table c
JOIN transaction_data t
    ON c.household_key = t.household_key
GROUP BY c.campaign
ORDER BY total_sales DESC;

-- 3.4.5 Campaign Period Performance
SELECT
    c.campaign,
    cd.start_day,
    cd.end_day,
    COUNT(DISTINCT c.household_key) AS households_targeted,
    ROUND(SUM(t.sales_value), 2) AS campaign_period_sales,
    SUM(t.quantity) AS quantity,
    COUNT(DISTINCT t.basket_id) AS transactions
FROM campaign_table c
JOIN campaign_desc cd
    ON c.campaign = cd.campaign
JOIN transaction_data t
    ON c.household_key = t.household_key
    AND t.day BETWEEN cd.start_day AND cd.end_day
GROUP BY
    c.campaign,
    cd.start_day,
    cd.end_day
ORDER BY campaign_period_sales DESC;

-- 3.4.6 Product Performance
SELECT
    p.product_id,
    p.department,
    p.commodity_desc,
    ROUND(SUM(t.sales_value), 2) AS sales,
    SUM(t.quantity) AS quantity,
    COUNT(DISTINCT t.basket_id) AS transactions
FROM transaction_data t
JOIN product p
    ON t.product_id = p.product_id
GROUP BY
    p.product_id,
    p.department,
    p.commodity_desc
ORDER BY sales DESC
LIMIT 20;

-- 3.4.7 Discount & Coupon Analysis
SELECT
    CASE
        WHEN coupon_disc < 0 THEN 'Coupon Used'
        ELSE 'No Coupon'
    END AS coupon_status,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT basket_id) AS transactions,
    ROUND(SUM(sales_value), 2) AS sales,
    ROUND(SUM(ABS(coupon_disc)), 2) AS coupon_discount,
    ROUND(AVG(sales_value), 2) AS avg_line_sales
FROM transaction_data
GROUP BY coupon_status
ORDER BY sales DESC;

-- 3.4.8 Household Value Analysis
SELECT
    household_key,
    ROUND(SUM(sales_value), 2) AS total_sales,
    SUM(quantity) AS quantity,
    COUNT(DISTINCT basket_id) AS transactions,
    ROUND(
        SUM(sales_value) / COUNT(DISTINCT basket_id),
        2
    ) AS avg_basket_value
FROM transaction_data
GROUP BY household_key
ORDER BY total_sales DESC
LIMIT 20;

-- 3.5.5 Final SQL vs Pandas Validation
SELECT campaign, COUNT(DISTINCT household_key) AS households
FROM campaign_table
GROUP BY campaign;

-- 3.6.1 Household-Level Metrics and Value Segmentation
WITH household_base AS (
    SELECT
        household_key,
        SUM(sales_value) AS sales,
        SUM(quantity) AS quantity,
        COUNT(DISTINCT basket_id) AS transactions,
        COUNT(DISTINCT product_id) AS purchase_breadth
    FROM transaction_data
    GROUP BY household_key
)
SELECT * FROM household_base;

-- 3.6.2 Building the Promotional Opportunity Score
WITH household_base AS (
    SELECT
        household_key,
        SUM(sales_value) AS sales,
        SUM(quantity) AS quantity,
        COUNT(DISTINCT basket_id) AS transactions,
        COUNT(DISTINCT product_id) AS purchase_breadth
    FROM transaction_data
    GROUP BY household_key
),

household_medians AS (
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales) AS sales_median,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY transactions) AS transactions_median
    FROM household_base
),

-- Engagement score: plain percentile rank across ALL households
household_engagement AS (
    SELECT
        household_key,
        PERCENT_RANK() OVER (ORDER BY sales) * 100 AS sales_score,
        PERCENT_RANK() OVER (ORDER BY transactions) * 100 AS transaction_score,
        PERCENT_RANK() OVER (ORDER BY purchase_breadth) * 100 AS breadth_score
    FROM household_base
),
household_engagement_scored AS (
    SELECT
        household_key,
        0.40 * sales_score + 0.30 * transaction_score + 0.30 * breadth_score AS engagement_score
    FROM household_engagement
),

-- Household-department level: artifact exclusion applied here
household_dept AS (
    SELECT
        t.household_key,
        p.department,
        SUM(t.sales_value) AS sales,
        COUNT(DISTINCT t.basket_id) AS transactions,
        SUM(t.quantity) AS quantity,
        COUNT(DISTINCT t.product_id) AS products
    FROM transaction_data t
    JOIN product p ON t.product_id = p.product_id
    WHERE p.department NOT IN ('MISC SALES TRAN', 'KIOSK-GAS', 'MISC. TRANS.')
    GROUP BY t.household_key, p.department
),

-- Department-count floor: same fix as notebook 2 cell 101
eligible_departments AS (
    SELECT department
    FROM household_dept
    GROUP BY department
    HAVING COUNT(DISTINCT household_key) >= 100
),

-- Category affinity: ranked WITHIN each department, not pooled
household_dept_scored AS (
    SELECT
        hd.household_key,
        hd.department,
        PERCENT_RANK() OVER (PARTITION BY hd.department ORDER BY hd.sales) * 100 AS sales_score,
        PERCENT_RANK() OVER (PARTITION BY hd.department ORDER BY hd.transactions) * 100 AS transaction_score,
        PERCENT_RANK() OVER (PARTITION BY hd.department ORDER BY hd.quantity) * 100 AS quantity_score,
        PERCENT_RANK() OVER (PARTITION BY hd.department ORDER BY hd.products) * 100 AS breadth_score
    FROM household_dept hd
    JOIN eligible_departments ed ON hd.department = ed.department
),
household_dept_affinity AS (
    SELECT
        household_key,
        department,
        0.30 * sales_score + 0.25 * transaction_score
            + 0.25 * quantity_score + 0.20 * breadth_score AS category_affinity_score
    FROM household_dept_scored
),

-- Each household's single best (highest-affinity) category
best_affinity AS (
    SELECT DISTINCT ON (household_key)
        household_key,
        department AS top_affinity_category,
        category_affinity_score
    FROM household_dept_affinity
    ORDER BY household_key, category_affinity_score DESC
),

-- Campaign responsiveness with reliability adjustment
campaign_scored AS (
    SELECT
        c.household_key,
        COUNT(DISTINCT c.campaign) AS campaigns_targeted,
        COUNT(DISTINCT r.campaign) AS campaigns_redeemed,
        (COUNT(DISTINCT r.campaign)::float / NULLIF(COUNT(DISTINCT c.campaign), 0)) * 100
            * (COUNT(DISTINCT c.campaign)::float / (COUNT(DISTINCT c.campaign) + 5)) AS campaign_score
    FROM campaign_table c
    LEFT JOIN coupon_redempt r
        ON c.household_key = r.household_key AND c.campaign = r.campaign
    GROUP BY c.household_key
),

-- Assemble full household score table
household_score_data AS (
    SELECT
        hb.household_key,
        hb.sales,
        hb.transactions,
        CASE
            WHEN hb.sales >= m.sales_median AND hb.transactions >= m.transactions_median
                THEN 'High Value - Frequent'
            WHEN hb.sales >= m.sales_median
                THEN 'High Value - Less Frequent'
            WHEN hb.transactions >= m.transactions_median
                THEN 'Low Value - Frequent'
            ELSE 'Low Value'
        END AS value_segment,
        COALESCE(cs.campaign_score, 0) AS campaign_score,
        he.engagement_score,
        COALESCE(ba.top_affinity_category, 'None') AS top_affinity_category,
        COALESCE(ba.category_affinity_score, 0) AS category_affinity_score
    FROM household_base hb
    CROSS JOIN household_medians m
    LEFT JOIN campaign_scored cs ON hb.household_key = cs.household_key
    LEFT JOIN household_engagement_scored he ON hb.household_key = he.household_key
    LEFT JOIN best_affinity ba ON hb.household_key = ba.household_key
),

-- Re-rank all three components to comparable percentile scales.
-- campaign_score_pct: zero group scores 0 explicitly; only non-zero
-- households are ranked against each other (the zero-inflation fix).
household_score_pct AS (
    SELECT
        *,
        CASE WHEN campaign_score = 0 THEN 0
            ELSE PERCENT_RANK() OVER (
                PARTITION BY (campaign_score = 0) ORDER BY campaign_score
             ) * 100
        END AS campaign_score_pct,
        PERCENT_RANK() OVER (ORDER BY category_affinity_score) * 100 AS category_affinity_pct,
        PERCENT_RANK() OVER (ORDER BY engagement_score) * 100 AS engagement_pct
    FROM household_score_data
)

-- Final promotional opportunity score: engagement 35%, category affinity 30%, campaign 35%
SELECT
    household_key,
    sales,
    value_segment,
    top_affinity_category,
    ROUND(campaign_score_pct::numeric, 2) AS campaign_score_pct,
    ROUND(category_affinity_pct::numeric, 2) AS category_affinity_pct,
    ROUND(engagement_pct::numeric, 2) AS engagement_pct,
    ROUND(
        (0.35 * engagement_pct + 0.30 * category_affinity_pct + 0.35 * campaign_score_pct)::numeric,
        2
    ) AS promotional_opportunity_score
FROM household_score_pct
ORDER BY promotional_opportunity_score DESC;
