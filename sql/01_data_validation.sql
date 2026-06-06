-- ============================================================
-- SCRIPT 01: DATA VALIDATION
-- Purpose: Verify data quality before any analysis
-- Analyst: Tanishka Suryawanshi
-- Date: June 2026
-- ============================================================
-- 1.1 Row count and coverage
SELECT COUNT(*) AS total_rows,
     COUNT(DISTINCT station_name) AS unique_stations,
     COUNT(DISTINCT date::date) AS unique_dates,
     MIN(date) AS start_date,
     MAX(date) AS end_date
FROM metro.ridership;
-- 1.2 Row counts by transaction type
SELECT transaction_type,
     COUNT(*) AS row_count
FROM metro.ridership
GROUP BY transaction_type
ORDER BY transaction_type;
-- 1.3 Row counts by line
SELECT line,
     COUNT(DISTINCT station_name) AS stations,
     COUNT(*) AS total_rows
FROM metro.ridership
GROUP BY line
ORDER BY line;
-- 1.4 Check for nulls in critical columns
SELECT SUM(
          CASE
               WHEN station_name IS NULL THEN 1
               ELSE 0
          END
     ) AS null_station,
     SUM(
          CASE
               WHEN line IS NULL THEN 1
               ELSE 0
          END
     ) AS null_line,
     SUM(
          CASE
               WHEN date IS NULL THEN 1
               ELSE 0
          END
     ) AS null_date,
     SUM(
          CASE
               WHEN daily_count IS NULL THEN 1
               ELSE 0
          END
     ) AS null_daily_count,
     SUM(
          CASE
               WHEN transaction_type IS NULL THEN 1
               ELSE 0
          END
     ) AS null_tx_type
FROM metro.ridership;
-- 1.5 Check for zero or negative ridership
SELECT COUNT(*) AS zero_or_negative_rows
FROM metro.ridership
WHERE daily_count <= 0;
-- 1.6 Check for duplicate records
SELECT date,
     station_name,
     transaction_type,
     COUNT(*) AS occurrences
FROM metro.ridership
GROUP BY date,
     station_name,
     transaction_type
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;
-- 1.7 Holiday distribution
SELECT is_holiday,
     is_weekend,
     COUNT(DISTINCT date::date) AS unique_dates
FROM metro.ridership
GROUP BY is_holiday,
     is_weekend
ORDER BY is_holiday,
     is_weekend;