# Project Log — Bengaluru Metro Analytics

## Phase 1 — Environment Setup
**Date completed:**  
**What was done:** Created project folder structure, initialized Git, created README  
**Tools used:** VS Code, Git  
**Skills demonstrated:** Version control, project organization  
**Interview talking points:**  
- "I structure every project before writing a single line of code because clean repos reflect professional habits" 

# Phase 2: Data Cleaning & Ingestion
## Bengaluru Metro Analytics Project

**Objective:** Load real BMRCL hourly ridership data, clean and standardize it,
enrich it with station metadata and holidays, then load into PostgreSQL.

**Data sources:**
- `station-hourly.xlsx` — Sep 2025 entry + exit counts (83 stations, hourly)
- `hourly_entry___exit_data.xlsx` — Aug 2025 entry counts (83 stations, partial month)
- `station_codes_enriched.xlsx` — Station master with line and interchange info
- `holidays.csv` — Bengaluru public holidays

- "Source data for Aug 2025 contained a duplicate H23 column; H22 was mislabeled. Fixed by direct column index reassignment" 
## Phase 1 and 2 — Data Cleaning & Ingestion
**Date completed:** 06-06-2026
**What was done:**
- Loaded real BMRCL operational data (Aug + Sep 2025, 83 stations)
- Standardized column names across two differently formatted source files
- Fixed duplicate H23 column bug in Aug source data
- Extracted line information (Purple/Green/Yellow) from station prefixes
- Added holiday and weekend flags
- Ran full data quality validation (nulls, duplicates, negatives)
- Loaded 6,335 rows into PostgreSQL metro.ridership table
- Loaded 91 station records into metro.stations table

**Skills demonstrated:** Data cleaning, schema standardization, data validation,
PostgreSQL ingestion, handling special characters in credentials, debugging
source data quality issues

**Interview talking point:** "The source data had a mislabeled duplicate column
in the Aug file — H22 was labeled H23. I caught it during validation, documented
it, and fixed it with a direct index reassignment rather than dropping the column,
preserving all the data."