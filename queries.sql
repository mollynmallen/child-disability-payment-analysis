-- queries.sql
-- Four analysis queries for the portfolio.
-- Run after load_data.sql and clean_data.sql.

-- ---------------------------------------------------------------------------
-- Q1. Monthly application volumes over time
-- Demonstrates: converting text dates to real dates for chronological sorting
-- ---------------------------------------------------------------------------
SELECT
    month,
    part1_registered,
    part2_received
FROM applications_clean
ORDER BY STRPTIME(month, '%B %Y');


-- ---------------------------------------------------------------------------
-- Q2. Award rate, calculated from raw counts (not the published percentages)
-- Demonstrates: derived metrics and safe division
-- ---------------------------------------------------------------------------
SELECT
    month,
    authorised,
    processed,
    ROUND(authorised * 100.0 / processed, 1) AS award_rate_pct
FROM applications_clean
WHERE processed > 0
ORDER BY STRPTIME(month, '%B %Y');


-- ---------------------------------------------------------------------------
-- Q3. Yearly totals and year-on-year change
-- Demonstrates: GROUP BY, date extraction, window function (LAG)
-- ---------------------------------------------------------------------------
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM STRPTIME(month, '%B %Y')) AS year,
        SUM(part1_registered) AS total_applications,
        SUM(authorised)      AS total_authorised
    FROM applications_clean
    GROUP BY year
)
SELECT
    year,
    total_applications,
    total_authorised,
    total_applications - LAG(total_applications) OVER (ORDER BY year)
        AS change_from_prev_year
FROM yearly
ORDER BY year;


-- ---------------------------------------------------------------------------
-- Q4. Overall decision breakdown across the full period
-- Demonstrates: conditional aggregation and ratio calculation
-- ---------------------------------------------------------------------------
SELECT
    SUM(authorised) AS total_authorised,
    SUM(denied)     AS total_denied,
    SUM(withdrawn)  AS total_withdrawn,
    ROUND(SUM(authorised) * 100.0 / SUM(processed), 1) AS pct_authorised,
    ROUND(SUM(denied)     * 100.0 / SUM(processed), 1) AS pct_denied,
    ROUND(SUM(withdrawn)  * 100.0 / SUM(processed), 1) AS pct_withdrawn
FROM applications_clean
WHERE processed > 0;
