-- ============================================================
-- SCRIPT 03: TIME-BASED ANALYSIS
-- Purpose: Understand ridership patterns across time
-- Business question: When are peaks? How do weekdays differ
--                    from weekends? What is the growth trend?
-- ============================================================
-- 3.1 Weekday vs Weekend vs Holiday comparison
SELECT CASE
          WHEN is_holiday THEN 'Holiday'
          WHEN is_weekend THEN 'Weekend'
          ELSE 'Weekday'
     END AS day_type,
     COUNT(DISTINCT date::date) AS days_in_sample,
     ROUND(AVG(daily_count), 0) AS avg_station_ridership,
     SUM(daily_count) AS total_ridership
FROM metro.ridership
WHERE transaction_type = 'Entry'
GROUP BY CASE
          WHEN is_holiday THEN 'Holiday'
          WHEN is_weekend THEN 'Weekend'
          ELSE 'Weekday'
     END
ORDER BY avg_station_ridership DESC;
-- 3.2 Day of week pattern
-- Business value: Shows which specific days are busiest
SELECT day_of_week,
     ROUND(AVG(daily_count), 0) AS avg_daily_entries,
     SUM(daily_count) AS total_entries,
     COUNT(*) AS data_points
FROM metro.ridership
WHERE transaction_type = 'Entry'
GROUP BY day_of_week
ORDER BY avg_daily_entries DESC;
-- 3.3 Daily network total trend (all stations combined)
-- Business value: Shows overall demand trend over the period
SELECT date::date AS business_date,
     day_of_week,
     is_weekend,
     is_holiday,
     SUM(daily_count) AS network_total_entries,
     COUNT(DISTINCT station_name) AS reporting_stations
FROM metro.ridership
WHERE transaction_type = 'Entry'
GROUP BY date::date,
     day_of_week,
     is_weekend,
     is_holiday
ORDER BY business_date;
-- 3.4 Month over month comparison (Aug vs Sep)
-- Aug data is partial (Aug 1-18 only) so we normalise by days
SELECT EXTRACT(
          MONTH
          FROM date
     ) AS month_num,
     TO_CHAR(date, 'Month') AS month_name,
     COUNT(DISTINCT date::date) AS days_of_data,
     SUM(daily_count) AS total_entries,
     ROUND(
          SUM(daily_count)::numeric / COUNT(DISTINCT date::date),
          0
     ) AS avg_daily_network_entries
FROM metro.ridership
WHERE transaction_type = 'Entry'
GROUP BY EXTRACT(
          MONTH
          FROM date
     ),
     TO_CHAR(date, 'Month')
ORDER BY month_num;
-- 3.5 Peak hour analysis across all stations
-- Which hours carry the most passengers network-wide?
SELECT hour_slot,
     SUM(hourly_entries) AS total_entries,
     ROUND(AVG(hourly_entries), 0) AS avg_entries_per_station_day
FROM (
          SELECT date,
               station_name,
               'H00' AS hour_slot,
               h00 AS hourly_entries
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H06',
               h06
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H07',
               h07
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H08',
               h08
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H09',
               h09
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H10',
               h10
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H17',
               h17
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H18',
               h18
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H19',
               h19
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT date,
               station_name,
               'H20',
               h20
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
     ) hourly
GROUP BY hour_slot
ORDER BY total_entries DESC;
-- 3.6 Peak hour by line
-- Business value: Do Purple and Green lines peak at the same time?
-- Critical for train scheduling decisions
SELECT line,
     hour_slot,
     ROUND(AVG(hourly_entries), 0) AS avg_hourly_entries
FROM (
          SELECT line,
               date,
               station_name,
               'H07' AS hour_slot,
               h07 AS hourly_entries
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT line,
               date,
               station_name,
               'H08',
               h08
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT line,
               date,
               station_name,
               'H09',
               h09
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT line,
               date,
               station_name,
               'H17',
               h17
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT line,
               date,
               station_name,
               'H18',
               h18
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
          UNION ALL
          SELECT line,
               date,
               station_name,
               'H19',
               h19
          FROM metro.ridership
          WHERE transaction_type = 'Entry'
     ) hourly
GROUP BY line,
     hour_slot
ORDER BY line,
     avg_hourly_entries DESC;