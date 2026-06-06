-- ============================================================
-- SCRIPT 04: ADVANCED ANALYTICS (Window Functions)
-- Purpose: Demonstrate SQL proficiency beyond basic aggregation
-- Business question: Trends, rankings, anomalies
-- ============================================================
-- 4.1 7-day rolling average per station
-- Business value: Smooths daily noise to show real trends
-- This is what operations teams actually use for planning
WITH daily_station AS (
     SELECT date::date AS dt,
          station_name,
          line,
          SUM(daily_count) AS daily_entries
     FROM metro.ridership
     WHERE transaction_type = 'Entry'
     GROUP BY date::date,
          station_name,
          line
)
SELECT dt,
     station_name,
     line,
     daily_entries,
     ROUND(
          AVG(daily_entries) OVER (
               PARTITION BY station_name
               ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ),
          0
     ) AS rolling_7day_avg,
     ROUND(
          daily_entries - AVG(daily_entries) OVER (
               PARTITION BY station_name
               ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ),
          0
     ) AS deviation_from_avg
FROM daily_station
WHERE station_name = 'Indiranagar'
ORDER BY dt;
-- 4.2 Station ranking within each line
-- Business value: Relative performance — is a station 
-- punching above or below its weight for its corridor?
SELECT station_name,
     line,
     SUM(daily_count) AS total_entries,
     RANK() OVER (
          PARTITION BY line
          ORDER BY SUM(daily_count) DESC
     ) AS rank_in_line,
     ROUND(
          SUM(daily_count) * 100.0 / SUM(SUM(daily_count)) OVER (PARTITION BY line),
          2
     ) AS pct_of_line
FROM metro.ridership
WHERE transaction_type = 'Entry'
     AND EXTRACT(
          MONTH
          FROM date
     ) = 9
GROUP BY station_name,
     line
ORDER BY line,
     rank_in_line;
-- 4.3 Day-over-day change per station
-- Business value: Sudden drops may indicate service issues
-- Sudden spikes may indicate events nearby
WITH daily AS (
     SELECT date::date AS dt,
          station_name,
          SUM(daily_count) AS entries
     FROM metro.ridership
     WHERE transaction_type = 'Entry'
     GROUP BY date::date,
          station_name
)
SELECT dt,
     station_name,
     entries,
     LAG(entries) OVER (
          PARTITION BY station_name
          ORDER BY dt
     ) AS prev_day_entries,
     entries - LAG(entries) OVER (
          PARTITION BY station_name
          ORDER BY dt
     ) AS day_over_day_change,
     ROUND(
          (
               entries - LAG(entries) OVER (
                    PARTITION BY station_name
                    ORDER BY dt
               )
          ) * 100.0 / NULLIF(
               LAG(entries) OVER (
                    PARTITION BY station_name
                    ORDER BY dt
               ),
               0
          ),
          1
     ) AS pct_change
FROM daily
ORDER BY ABS(
          entries - LAG(entries) OVER (
               PARTITION BY station_name
               ORDER BY dt
          )
     ) DESC NULLS LAST
LIMIT 20;
-- 4.4 Identify anomaly days — network-wide ridership 
-- more than 2 standard deviations below average
-- Business value: Flags holidays, disruptions, data issues
WITH daily_network AS (
     SELECT date::date AS dt,
          is_holiday,
          is_weekend,
          SUM(daily_count) AS network_entries
     FROM metro.ridership
     WHERE transaction_type = 'Entry'
     GROUP BY date::date,
          is_holiday,
          is_weekend
)
SELECT dt,
     network_entries,
     is_holiday,
     is_weekend,
     ROUND(AVG(network_entries) OVER (), 0) AS overall_avg,
     ROUND(STDDEV(network_entries) OVER (), 0) AS overall_stddev,
     ROUND(
          (network_entries - AVG(network_entries) OVER ()) / NULLIF(STDDEV(network_entries) OVER (), 0),
          2
     ) AS z_score
FROM daily_network
ORDER BY z_score ASC;
-- 4.5 Top 5 stations per line on weekdays vs weekends
-- Business value: Weekend top stations differ from weekday —
-- useful for targeted service planning
SELECT line,
     station_name,
     day_type,
     avg_daily_entries,
     rank_in_line_daytype
FROM (
          SELECT line,
               station_name,
               CASE
                    WHEN is_weekend THEN 'Weekend'
                    ELSE 'Weekday'
               END AS day_type,
               ROUND(AVG(daily_count), 0) AS avg_daily_entries,
               RANK() OVER (
                    PARTITION BY line,
                    CASE
                         WHEN is_weekend THEN 'Weekend'
                         ELSE 'Weekday'
                    END
                    ORDER BY AVG(daily_count) DESC
               ) AS rank_in_line_daytype
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          GROUP BY line,
               station_name,
               is_weekend
     ) ranked
WHERE rank_in_line_daytype <= 5
ORDER BY line,
     day_type,
     rank_in_line_daytype;