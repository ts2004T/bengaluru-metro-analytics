# Bengaluru Metro Ridership Analytics

![Status](https://img.shields.io/badge/Status-Complete-brightgreen) ![Python](https://img.shields.io/badge/Python-3.12-blue) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-blue) ![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow)

End-to-end analytics on real BMRCL operational data across 83 stations — SQL analysis, Python EDA, Power BI dashboard, and a 30-day Prophet forecast. Built to answer a concrete operations question: *where should a metro network focus resources to move the most people, most efficiently?*

---

## The Problem

Bengaluru Metro carries 700,000+ passengers daily across 83 stations on three lines. Without data-driven planning, decisions about train frequency, staffing, and capacity rely on intuition rather than evidence.

This project answers five operational questions:

1. Which stations drive disproportionate ridership — and which are underperforming relative to their position in the network?
2. When do peaks occur, and does peak timing vary meaningfully by station type?
3. How does weekday demand compare to weekends and holidays?
4. How do the Purple, Green, and Yellow lines compare on per-station efficiency?
5. What ridership volume should operations plan for next month?

---

## The Data

**Source:** Real BMRCL operational data — hourly entry and exit counts per station
**Coverage:** August–September 2025, 83 stations, 6,335 records
**Lines:** Purple (37 stations), Green (31 stations), Yellow (15 stations)
**Granularity:** Daily totals plus 24 hourly breakdown columns per station

One quality issue: raw timestamps had inconsistent timezone handling across data exports. This was resolved by standardising all records to IST at ingestion and flagging the 12 records where the transformation was ambiguous.

> Raw operational files are excluded from this repository. The cleaning notebook documents all transformations applied.

---

## The Approach

**1. Ingestion & Cleaning (Python + PostgreSQL)**
Loaded BMRCL source files into a PostgreSQL 18 schema after standardising column formats, resolving timezone inconsistencies, and validating row counts across daily exports. Data quality checks are documented in `sql/01_data_validation.sql`.

**2. SQL Analysis**
Four analytical layers, each building on the last:
- Station KPIs — daily averages, ranking, concentration ratios
- Time-series analysis — peak hour identification by station type, weekday vs. weekend splits
- Line comparison — per-station efficiency metrics across Purple, Green, and Yellow
- Window functions — percentile banding, anomaly flagging, rolling averages

**3. Exploratory Data Analysis (Python)**
Seven visualisations covering ridership distribution, peak hour heatmaps, line comparison, and anomaly detection. All charts are in `reports/`.

**4. Power BI Dashboard**
Four-page interactive dashboard with six DAX measures — Executive Summary, Station Intelligence, Time Patterns, Line Comparison. Built for an operations stakeholder, not a data team.

**5. Prophet Forecasting Model**
30-day forward forecast validated with time series cross-validation. Final model selected after comparing MAPE across three window sizes.

---

## The Numbers

| Metric | Finding |
|---|---|
| Top station | Kempegowda handles 4.7% of total network entries — single point of failure risk |
| Weekday premium | Weekday ridership is 28.9% higher than weekends — commuter-dominated demand |
| Peak hour | Network-wide PM peak at 18:00–19:00, but varies significantly by station type |
| Line efficiency gap | Purple Line averages 11K entries/station/day vs Yellow Line's 4K — a 63% gap |
| Concentration | 59% of stations drive 80% of total ridership |
| Forecast | Oct 2025 projected at 760,852 average daily entries (+7.9% growth) |
| Forecast accuracy | Prophet model achieved **5.2% MAPE** via cross-validation |

Five business recommendations derived from the analysis — including a Yellow Line demand audit estimated at ₹88L additional monthly revenue potential and a tiered service frequency strategy projected to reduce empty train kilometres by 8–12%.

---

## Reflection

The 63% per-station efficiency gap between the Purple and Yellow Lines was the finding that surprised me most. I expected variation — the lines serve different demographics and corridors — but not at that scale. It changed how I framed the analysis: aggregate network metrics mask serious line-level underperformance, and any operations recommendation built on network averages would be misleading.

The forecasting model also taught me something I hadn't expected: cross-validation for time series is harder than it looks. A single train-test split on seasonal data will overfit to the specific seasonal pattern in the test period. Switching to Prophet's built-in cross-validation with rolling windows brought the MAPE down from 8.1% to 5.2% — a meaningful improvement, and one I wouldn't have found without building validation into the methodology from the start.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL 18 | Primary data store, schema design, window function analysis |
| Python 3.12 | Data cleaning, EDA, forecasting |
| pandas / numpy | Data manipulation |
| matplotlib / seaborn | Visualisation |
| Prophet | Time series forecasting |
| SQLAlchemy | Database ORM |
| Power BI Desktop | Interactive 4-page dashboard |

---

## Project Structure

```
bengaluru-metro-analytics/
├── notebooks/
│   ├── 01_data_cleaning.ipynb    # ETL and PostgreSQL ingestion
│   ├── 02_eda.ipynb              # EDA and visual analysis
│   └── 03_forecasting.ipynb      # Prophet forecasting model
├── sql/
│   ├── 01_data_validation.sql    # Data quality checks
│   ├── 02_station_kpis.sql       # Station performance metrics
│   ├── 03_time_analysis.sql      # Time-based insights
│   └── 04_advanced_analytics.sql # Window functions and anomaly detection
├── reports/                      # Dashboard screenshots and charts
└── docs/
    ├── project_log.md
    └── business_recommendations.md
```

---

## Resume Bullet

> Built end-to-end ridership analytics pipeline for 83-station metro network using PostgreSQL, Python, and Power BI; developed Prophet forecasting model achieving 5.2% MAPE, projecting 7.9% ridership growth for Oct 2025 and identifying a 63% line-efficiency gap that underpinned 5 operational recommendations including a tiered service frequency strategy.

---

**Tanishka Suryawanshi** · BTech CSE, SRM University · [GitHub](https://github.com/ts2004T)
