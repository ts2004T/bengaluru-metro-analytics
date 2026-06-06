-- ============================================================
-- SCRIPT 02: STATION-LEVEL KPIs
-- Purpose: Identify top/bottom performing stations
-- Business question: Which stations drive the most ridership?
--                    Where should operations focus resources?
-- ============================================================
-- 2.1 Top 15 stations by total entries (Sep 2025)
SELECT station_name,
     line,
     SUM(daily_count) AS total_entries,
     ROUND(AVG(daily_count), 0) AS avg_daily_entries,
     MAX(daily_count) AS peak_day_entries,
     MIN(daily_count) AS lowest_day_entries
FROM metro.ridership
WHERE transaction_type = 'Entry'
     AND EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY station_name,
     line
ORDER BY total_entries DESC
LIMIT 15;
-- 2.2 Bottom 10 stations by total entries (Sep 2025)
-- Business value: Identifies underutilised stations
SELECT station_name,
     line,
     SUM(daily_count) AS total_entries,
     ROUND(AVG(daily_count), 0) AS avg_daily_entries
FROM metro.ridership
WHERE transaction_type = 'Entry'
     AND EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY station_name,
     line
ORDER BY total_entries ASC
LIMIT 10;
-- 2.3 Line-level comparison
-- Business value: Which corridor carries more load?
SELECT line,
     COUNT(DISTINCT station_name) AS station_count,
     SUM(daily_count) AS total_entries,
     ROUND(AVG(daily_count), 0) AS avg_daily_per_station,
     ROUND(
          SUM(daily_count)::numeric / COUNT(DISTINCT station_name),
          0
     ) AS entries_per_station
FROM metro.ridership
WHERE transaction_type = 'Entry'
     AND EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY line
ORDER BY total_entries DESC;
-- 2.4 Entry vs Exit balance per station
-- Business value: Stations where entries >> exits may indicate 
-- data issues OR strong one-directional flows (e.g. office areas)
SELECT station_name,
     line,
     SUM(
          CASE
               WHEN transaction_type = 'Entry' THEN daily_count
               ELSE 0
          END
     ) AS total_entries,
     SUM(
          CASE
               WHEN transaction_type = 'Exit' THEN daily_count
               ELSE 0
          END
     ) AS total_exits,
     SUM(
          CASE
               WHEN transaction_type = 'Entry' THEN daily_count
               ELSE 0
          END
     ) - SUM(
          CASE
               WHEN transaction_type = 'Exit' THEN daily_count
               ELSE 0
          END
     ) AS entry_exit_gap,
     ROUND(
          SUM(
               CASE
                    WHEN transaction_type = 'Entry' THEN daily_count
                    ELSE 0
               END
          )::numeric / NULLIF(
               SUM(
                    CASE
                         WHEN transaction_type = 'Exit' THEN daily_count
                         ELSE 0
                    END
               ),
               0
          ),
          2
     ) AS entry_exit_ratio
FROM metro.ridership
WHERE EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY station_name,
     line
ORDER BY ABS(
          SUM(
               CASE
                    WHEN transaction_type = 'Entry' THEN daily_count
                    ELSE 0
               END
          ) - SUM(
               CASE
                    WHEN transaction_type = 'Exit' THEN daily_count
                    ELSE 0
               END
          )
     ) DESC
LIMIT 20;
-- 2.5 Station share of total network ridership
-- Business value: Concentration risk — how dependent is the 
-- network on a small number of stations?
SELECT station_name,
     line,
     SUM(daily_count) AS total_entries,
     ROUND(
          SUM(daily_count) * 100.0 / SUM(SUM(daily_count)) OVER (),
          2
     ) AS pct_of_network,
     SUM(SUM(daily_count)) OVER (
          ORDER BY SUM(daily_count) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
     ) AS running_total
FROM metro.ridership
WHERE transaction_type = 'Entry'
     AND EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY station_name,
     line
ORDER BY total_entries DESC;