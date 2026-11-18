-- load_data.sql
-- Loads the raw published spreadsheet into DuckDB.
-- Assumes the file has already been exported from Excel/Numbers as CSV
-- with headers, and saved as CDPJune2026Applications.csv.

DROP TABLE IF EXISTS applications;

CREATE TABLE applications AS
SELECT *
FROM read_csv_auto('CDPJune2026Applications.csv', header = true);
