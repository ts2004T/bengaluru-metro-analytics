# Project Log — Bengaluru Metro Analytics & Ridership Forecasting
**Author:** Tanishka Suryawanshi  
**Project start:** 06-06-2026  
**Project end:** 08-06-2026  
**GitHub:** https://github.com/ts2004T/bengaluru-metro-analytics

---

## Phase 1 — Environment Setup & Project Initialisation
**Date completed:** 06-06-2026

**What was done:**
- Created project folder structure on D: drive
- Initialised Git repository and connected to GitHub remote
- Created .gitignore excluding venv, .env, raw data files, and .pbix files
- Created placeholder README.md
- Set up PostgreSQL connection on port 5433
- Resolved broken venv issue — recreated using Miniconda Python base
- Registered Metro Project kernel for Jupyter notebooks in VS Code

**Tools used:** Git, GitHub, VS Code, PostgreSQL 18, Python 3.12

**Skills demonstrated:** Version control, project organisation, 
environment management, debugging

**Files created:**
- README.md
- .gitignore
- docs/project_log.md
- Folder structure: data/raw, data/processed, data/external, 
  notebooks/, sql/, reports/, docs/

**Interview talking points:**
- "I structure every project before writing a single line of code — 
  clean repos signal professional habits to anyone reviewing your GitHub"
- "I hit a broken venv early on where the activate.bat was missing — 
  diagnosed it by checking dir venv/Scripts/ and recreated it cleanly"

---

## Phase 2 — Data Cleaning & Ingestion
**Date completed:** 06-06-2026

**What was done:**
- Loaded real BMRCL operational data (Aug + Sep 2025, 83 stations)
- Identified and fixed duplicate H23 column in Aug source file — 
  H22 was mislabeled as H23 in the raw data
- Standardized column names across two differently formatted source 
  files (Aug used verbose hour labels, Sep used H00–H23 format)
- Extracted line information (Purple/Green/Yellow) from station 
  name prefixes (1xx = Purple, 2xx = Green, 3xx = Yellow)
- Added holiday and weekend boolean flags
- Ran full data quality validation: null checks, duplicate detection, 
  zero/negative value checks, date coverage verification
- Loaded 6,335 rows into PostgreSQL metro.ridership table
- Loaded 91 station records into metro.stations table
- Secured credentials using python-dotenv and .env file
- Created .env.example for repo documentation

**Tools used:** Python, pandas, SQLAlchemy, psycopg2, PostgreSQL, 
python-dotenv

**Skills demonstrated:** Data cleaning, schema standardization, 
data validation, PostgreSQL ingestion, credential management, 
debugging source data quality issues

**Files created:**
- notebooks/01_data_cleaning.ipynb
- data/processed/ridership_clean.csv
- data/processed/powerbi_ridership.csv
- .env.example
- requirements.txt

**Key data quality issues found and resolved:**
- Aug file had duplicate H23 column — H22 mislabeled at source
- Aug and Sep files used different column naming conventions
- Password contained special character (@) requiring URL encoding 
  in SQLAlchemy connection string

**Interview talking points:**
- "The source data had a mislabeled duplicate column in the Aug file — 
  H22 was labeled H23. I caught it during schema inspection, documented 
  it, and fixed it with direct index reassignment rather than dropping 
  the column, preserving all the data"
- "I used dotenv to manage credentials — never hardcode passwords in 
  notebooks that might be pushed to a public repo"

---

## Phase 3 — SQL Analysis
**Date completed:** 06-06-2026

**What was done:**
- Connected DBeaver to PostgreSQL on port 5433
- Wrote 4 SQL script files covering the full analytics workflow
- Ran all queries and validated results against known data facts

**Tools used:** PostgreSQL, DBeaver, SQL

**Skills demonstrated:** Intermediate to advanced SQL, window functions, 
CTEs, CASE statements, NULLIF for safe division, schema-qualified queries, 
time-series aggregation, KPI definition

**Files created:**
- sql/01_data_validation.sql
- sql/02_station_kpis.sql
- sql/03_time_analysis.sql
- sql/04_advanced_analytics.sql

**Key queries written:**
- Null checks, duplicate detection, coverage verification
- Top/bottom station rankings by total entries
- Entry vs exit balance per station (entry_exit_ratio)
- Line-level comparison with entries per station metric
- Weekday vs weekend vs holiday comparison
- Day of week pattern analysis
- Monthly normalised comparison (Aug partial vs Sep full)
- Peak hour analysis network-wide and by line
- 7-day rolling average using window functions
- Station ranking within each line using RANK() OVER (PARTITION BY)
- Day-over-day change using LAG()
- Anomaly detection using z-score in SQL
- Top 5 stations per line by day type (weekday vs weekend)

**Interview talking points:**
- "I used LAG() to calculate day-over-day ridership change per station — 
  in a production setting this would flag service disruptions automatically"
- "The entry/exit balance query revealed stations with strong directional 
  flow — useful for understanding whether a station serves trip origins 
  or destinations"
- "I used z-scores in SQL to flag anomaly days without hardcoding 
  thresholds — the detection scales automatically as data grows"
- "Window functions let me rank stations within each line without losing 
  the individual row detail that GROUP BY would collapse"

---

## Phase 4 — Exploratory Data Analysis
**Date completed:** 06-06-2026

**What was done:**
- Built a fully documented EDA notebook with markdown cells explaining 
  every analysis decision
- Generated 7 publication-quality visualisations with dark theme styling
- Applied consistent colour coding: Purple #9b59b6, Green #2ecc71, 
  Yellow #f1c40f
- Documented key findings with business interpretations

**Tools used:** Python, pandas, matplotlib, seaborn, SQLAlchemy

**Skills demonstrated:** Exploratory data analysis, data visualisation, 
hypothesis-driven analysis, business interpretation of findings, 
Python for analytics

**Files created:**
- notebooks/02_eda.ipynb
- reports/01_daily_network_trend.png
- reports/02_top15_stations.png
- reports/03_ridership_concentration.png
- reports/04_hourly_heatmap.png
- reports/05_hourly_profile.png
- reports/06_line_comparison.png
- reports/07_anomaly_detection.png

**Key findings:**
- Network handles ~724,042 entries/day (Sep 2025 average)
- Kempegowda top station at 1,020,459 entries in Sep — 4.7% of network
- Weekday ridership 28.9% higher than weekends
- PM peak at 18:00–19:00 dominates network-wide
- Peak timing varies by station: IT corridors peak AM, commercial 
  zones peak PM
- 7 anomaly days flagged via z-score — all correspond to holidays 
  or Sundays, validating the pipeline
- 59% of stations drive 80% of ridership (Pareto concentration)
- Purple Line: 55.6% of total entries; Green: 38.5%; Yellow: 6%

**Interview talking points:**
- "The hourly heatmap revealed that not all stations share the same 
  peak hour — Benniganahalli peaks sharply at 08:00 while MG Road 
  peaks at 18:00. A blanket peak-hours policy would miss this entirely"
- "Zero false positives in anomaly detection — all 7 flagged days 
  were holidays or Sundays. This validates the data pipeline and 
  the holiday flag logic"
- "The concentration chart is essentially a Pareto analysis — 59% 
  of stations drive 80% of demand, which directly supports the 
  tiered service frequency recommendation"

---

## Phase 5 — Power BI Dashboard
**Date completed:** 06-06-2026

**What was done:**
- Exported cleaned data from PostgreSQL to CSV for Power BI ingestion
- Built 4-page interactive dashboard with consistent dark theme
- Created 6 DAX measures for reusable KPI calculations
- Resolved date hierarchy issue by exporting date as YYYY-MM-DD string
- Applied consistent line colour scheme across all visuals
- Configured cross-filtering behaviour between visuals

**Tools used:** Power BI Desktop, DAX, PostgreSQL

**Skills demonstrated:** Business intelligence dashboarding, DAX measure 
creation, data visualisation design, cross-filtering, Power Query 
transformations

**Files created:**
- reports/bengaluru_metro_dashboard.pbix
- reports/dashboard_p1_executive.png
- reports/dashboard_p2_stations.png
- reports/dashboard_p3_time.png
- reports/dashboard_p4_lines.png

**DAX measures created:**
- Total Entries
- Avg Daily Entries
- Avg Weekday Entries
- Active Stations
- Peak Hour
- Weekday vs Weekend %

**Dashboard pages:**
1. Executive Summary — 6 KPI cards, daily trend line, ridership 
   donut by line
2. Station Intelligence — Top 15 bar chart, Bottom 15 bar chart, 
   line performance matrix
3. Time Patterns — day type comparison, day of week analysis, 
   line slicer
4. Line Comparison — Purple/Green/Yellow column charts, Yellow 
   Line station deep dive

**Technical issues resolved:**
- Power BI auto date/time hierarchy prevented clean date axis — 
  fixed by exporting date as YYYY-MM-DD text string
- Cross-filtering between KPI cards and charts — resolved by 
  understanding Power BI interaction model
- Special character in PostgreSQL password (@) broke SQLAlchemy 
  connection URL — fixed using connect_args parameter

**Interview talking points:**
- "I built DAX measures before any visuals — that's the professional 
  approach because measures are reusable across all pages and ensure 
  consistent calculations everywhere"
- "I hit the Power BI date hierarchy problem that trips up most 
  beginners — solved it by exporting date as ISO format string so 
  it sorts correctly without triggering the hierarchy"

---

## Phase 6 — Forecasting Model
**Date completed:** 07-06-2026

**What was done:**
- Built a Facebook Prophet time series forecasting model for 
  network-level daily ridership
- Integrated Bengaluru public holidays into the model to prevent 
  holiday dips from distorting the trend
- Generated 30-day forecast for October 2025 with 95% confidence 
  intervals
- Evaluated model accuracy using cross-validation (initial=30 days, 
  horizon=7 days)
- Generated individual station forecasts for top 5 stations
- Saved 3 visualisations: network forecast, components breakdown, 
  station forecasts

**Tools used:** Python, Prophet, SQLAlchemy, matplotlib

**Skills demonstrated:** Time series forecasting, cross-validation, 
confidence intervals, holiday effects modelling, model evaluation, 
hyperparameter reasoning

**Files created:**
- notebooks/03_forecasting.ipynb
- reports/08_network_forecast.png
- reports/09_forecast_components.png
- reports/10_station_forecasts.png

**Model configuration decisions:**
- changepoint_prior_scale=0.05 — conservative setting because only 
  49 days of training data; prevents overfitting to noise
- yearly_seasonality=False — insufficient data to fit annual patterns
- weekly_seasonality=True — strong and clearly visible in the data
- interval_width=0.95 — 95% confidence intervals for operational use
- holidays integrated — prevents holiday dips from distorting trend

**Results:**
- Network forecast Oct 2025: 760,852 avg daily entries (+7.9%)
- Model MAPE: 5.2% via cross-validation
- Top station: Kempegowda projected at 33,938 entries/day
- 95% CI: approximately 650,000 to 870,000 daily entries

**Interview talking points:**
- "I used Prophet because it handles weekly seasonality and holidays 
  natively — both critical for metro ridership where weekends are 
  29% lower than weekdays and holidays drop a further 35–40%"
- "With only 49 days of training data I set changepoint_prior_scale 
  conservatively at 0.05 to avoid overfitting — a higher value would 
  have the model chasing noise"
- "5.2% MAPE means predictions are within ~40,000 entries of actual 
  daily network totals — operationally useful for staffing and train 
  frequency planning"
- "I used cross-validation rather than a simple train/test split 
  because with limited data, cross-validation gives a more reliable 
  accuracy estimate by simulating multiple forecast origins"

---

## Phase 7 — Business Recommendations
**Date completed:** 08-06-2026

**What was done:**
- Wrote a full business recommendations document translating all 
  analytical findings into 5 actionable operational insights
- Quantified business impact for each recommendation with revenue 
  estimates using BMRCL's published average fare of ₹28
- Mapped every recommendation back to specific SQL queries, charts, 
  and notebook evidence
- Prioritised recommendations by urgency and implementation effort

**Files created:**
- docs/business_recommendations.md

**Recommendations summary:**
1. Tiered service frequency — 8–12% reduction in empty train km
2. Yellow Line demand audit — ₹88L additional monthly revenue potential
3. Weekend revenue optimisation — ₹1.2Cr additional monthly revenue 
   potential from 10% weekend improvement
4. Station-specific peak hour planning — safety and satisfaction impact
5. October 2025 proactive capacity planning — based on 7.9% forecast

**Interview talking points:**
- "Every recommendation maps back to a specific query or chart — 
  I can point to exact evidence for every claim I make"
- "I quantified revenue impact using BMRCL's published ₹28 average 
  fare — that's what separates business analysis from just describing 
  data patterns"
- "I included a methodology notes section explicitly stating the 
  limitations — only 49 days of data, Aug entry-only — because 
  honest uncertainty quantification is part of good analysis"

---

## Phase 8 — Final Documentation & Portfolio
**Date completed:** 08-06-2026

**What was done:**
- Rewrote README with findings table, dashboard previews, project 
  architecture diagram, tech stack table, how-to-run instructions
- Added shield badges for project status, Python, PostgreSQL, Power BI
- Documented all 5 business recommendations in summary form in README
- Completed project log across all 8 phases
- Drafted LinkedIn post for project announcement
- Finalised resume bullet with specific metrics

**Files created/updated:**
- README.md (complete rewrite)
- docs/project_log.md (this file — complete)

**Final project stats:**
- 3 Python notebooks (cleaning, EDA, forecasting)
- 4 SQL scripts (validation, KPIs, time analysis, advanced analytics)
- 7 EDA visualisations
- 3 forecast charts
- 4 Power BI dashboard pages
- 6 DAX measures
- 1 Prophet forecasting model (5.2% MAPE)
- 5 business recommendations with revenue estimates
- 8 Git commits telling the complete project story

**Resume bullet (final):**
> Built end-to-end ridership analytics pipeline for 83-station metro 
> network using PostgreSQL, Python, and Power BI; developed Prophet 
> forecasting model achieving 5.2% MAPE, projecting 7.9% ridership 
> growth for Oct 2025 and delivering 5 operational recommendations 
> including a Yellow Line demand audit and tiered service frequency 
> strategy

---

## Skills Demonstrated Across Project

| Skill | Evidence |
|---|---|
| SQL (intermediate/advanced) | Window functions, CTEs, LAG, RANK, z-scores |
| Python for analytics | pandas, matplotlib, seaborn, Prophet, SQLAlchemy |
| Data cleaning | Schema standardization, null handling, duplicate detection |
| Database design | PostgreSQL schema, table relationships |
| Data visualisation | 10 charts across EDA and forecasting |
| Business intelligence | 4-page Power BI dashboard, 6 DAX measures |
| Time series forecasting | Prophet model, cross-validation, MAPE evaluation |
| Business thinking | 5 recommendations with quantified revenue impact |
| Version control | Clean Git history, professional commit messages |
| Documentation | README, project log, business recommendations |
| Credential management | dotenv, .env.example pattern |
| Data quality | Validation framework applied before every load |

---

## Interview Preparation Summary

**One-paragraph project summary:**
"I built an end-to-end analytics pipeline using real BMRCL operational 
data — 83 stations, hourly entry and exit counts for August and September 
2025. I cleaned and ingested the data into PostgreSQL, wrote SQL queries 
covering KPIs, window functions, and anomaly detection, built a Python 
EDA notebook with 7 visualisations, and created a 4-page Power BI 
dashboard. I then built a Prophet forecasting model projecting October 
2025 ridership at 760,852 daily entries with 5.2% MAPE. The key findings 
were: Kempegowda handles 4.7% of network ridership creating a single 
point of failure risk; weekday demand is 29% higher than weekends; and 
Yellow Line underperforms Purple Line by 63% per station. My five 
business recommendations include a tiered service frequency strategy 
and a Yellow Line demand audit that could generate ₹88 lakhs in 
additional monthly revenue."

**Numbers to memorise:**
- 83 stations, 3 lines, 6,335 records
- 724,042 avg daily entries (historical)
- 760,852 avg daily entries (Oct forecast)
- 5.2% MAPE
- 7.9% projected growth
- 28.9% weekday premium
- 4.7% — Kempegowda share of network
- 63% — Yellow vs Purple per-station gap
- ₹88L — Yellow Line revenue opportunity