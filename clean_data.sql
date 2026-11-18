-- clean_data.sql
-- Cleans the raw table: renames columns, casts types, removes summary rows.
-- Uses TRY_STRPTIME to keep only rows whose month parses as a valid date,
-- which automatically excludes 'Total', 'Financial Year', headers, and notes.

DROP TABLE IF EXISTS applications_clean;

CREATE TABLE applications_clean AS
SELECT
    "Month [note 3] [note 4] [note 10]" AS month,

    TRY_CAST(REPLACE("Total part 1 applications registered [note 5]", ',', '') AS INTEGER)
        AS part1_registered,

    TRY_CAST(REPLACE("Percentage of total part 1 applications registered", ',', '') AS DOUBLE)
        AS pct_part1_registered,

    TRY_CAST(REPLACE("Total part 2 applications received [note 6] [note 7]", ',', '') AS INTEGER)
        AS part2_received,

    TRY_CAST(REPLACE("Percentage of total part 2 applications received", ',', '') AS DOUBLE)
        AS pct_part2_received,

    TRY_CAST(REPLACE("Total applications processed [note 8] [note 9]", ',', '') AS INTEGER)
        AS processed,

    TRY_CAST(REPLACE("Authorised applications [note 9]", ',', '') AS INTEGER)
        AS authorised,

    TRY_CAST(REPLACE("Denied applications [note 9]", ',', '') AS INTEGER)
        AS denied,

    TRY_CAST(REPLACE("Withdrawn applications [note 9]", ',', '') AS INTEGER)
        AS withdrawn,

    TRY_CAST(REPLACE("Percentage of processed applications authorised", ',', '') AS DOUBLE)
        AS pct_authorised,

    TRY_CAST(REPLACE("Percentage of processed applications denied", ',', '') AS DOUBLE)
        AS pct_denied,

    TRY_CAST(REPLACE("Percentage of processed applications withdrawn", ',', '') AS DOUBLE)
        AS pct_withdrawn

FROM applications
WHERE TRY_STRPTIME("Month [note 3] [note 4] [note 10]", '%B %Y') IS NOT NULL;

-- Save the cleaned data for use in the dashboard and for version control.
COPY applications_clean TO 'applications_clean.csv' (HEADER, DELIMITER ',');
