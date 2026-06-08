# Business Recommendations

## Bengaluru Metro Analytics & Ridership Forecasting

**Prepared by:** Tanishka Suryawanshi  
**Data period:** August–September 2025 (83 stations, 6,335 records)  
**Tools used:** PostgreSQL, Python, Prophet, Power BI

---

## Executive Summary

Analysis of real BMRCL operational data across 83 stations reveals five
actionable opportunities to improve operational efficiency, revenue, and
passenger experience. The network handles approximately 724,000 entries
per day with significant variation by station, line, and time of day.
A 30-day forecast projects 7.9% growth in October 2025, requiring
proactive capacity planning at high-demand stations.

---

## Recommendation 1: Implement Tiered Service Frequency by Station Demand

**Finding:**
49 of 83 stations (59%) account for 80% of total network ridership.
The remaining 34 stations share only 20% of demand. Kempegowda alone
handles 4.7% of total network entries — nearly 1 million in September.

**Recommendation:**
Classify stations into three demand tiers and align train frequency
accordingly:

| Tier   | Criteria (monthly entries) | Estimated stations | Suggested peak frequency |
| ------ | -------------------------- | -----------------: | ------------------------ |
| High   | > 500K                     |                 ~8 | Every 3–4 min            |
| Medium | 200K–500K                  |                ~25 | Every 5–7 min            |
| Low    | < 200K                     |                ~50 | Every 10–12 min          |

**Business impact:**
Reallocating train frequency from low-demand to high-demand stations
during peak hours reduces overcrowding at top stations while cutting
operational costs on underutilised routes. Estimated potential: 8–12%
reduction in empty train kilometres.

**Data evidence:**

- SQL Query: `02_station_kpis.sql` — station ranking and concentration
- Chart: `02_top15_stations.png`, `03_ridership_concentration.png`

---

## Recommendation 2: Yellow Line Demand Audit and Service Review

**Finding:**
The Yellow Line averages only 4,000 entries per station per day compared
to Purple Line's 11,000 — a 63% underperformance gap. With 15 stations
and 1.58M total entries in September, Yellow Line contributes only 5.98%
of network ridership despite representing 18% of stations.

**Recommendation:**
Commission a demand audit for the Yellow Line covering:

1. Last-mile connectivity gaps — are stations reachable without a vehicle?
2. Competing transport options — do parallel bus routes reduce metro demand?
3. Catchment area analysis — what is the population density within 1km of
   each Yellow Line station?
4. Fare sensitivity — is the Yellow Line fare structure discouraging trips?

**Business impact:**
A 20% ridership improvement on Yellow Line would add ~316,000 monthly
entries and approximately ₹88 lakhs in additional monthly revenue
(at avg fare of ₹28).

**Data evidence:**

- SQL Query: `02_station_kpis.sql` — line-level comparison
- Chart: `06_line_comparison.png`
- Power BI: Line Comparison page, Yellow Line deep dive

---

## Recommendation 3: Weekend and Holiday Revenue Optimisation

**Finding:**
Weekday ridership is 28.9% higher than weekends. Holiday ridership drops
to approximately 60–65% of normal weekday levels. This represents
significant unused capacity on weekends and holidays when trains are
running at reduced passenger loads.

**Recommendation:**
Introduce targeted weekend and holiday demand stimulation:

1. **Weekend leisure packages:** Partner with Bengaluru tourism
   attractions (Lalbagh, Cubbon Park, museums) for bundled metro +
   entry tickets sold via the BMRCL app
2. **Holiday surge pricing (reverse):** Offer 15–20% fare discounts on
   public holidays to stimulate discretionary travel
3. **Corporate weekend passes:** Target IT companies in Whitefield and
   Electronic City corridors with subsidised weekend passes for employees

**Business impact:**
A 10% improvement in weekend ridership across 83 stations would generate
approximately ₹1.2 crore additional monthly revenue.

**Data evidence:**

- SQL Query: `03_time_analysis.sql` — weekday vs weekend comparison
- Chart: `05_hourly_profile.png`
- Power BI: Time Patterns page

---

## Recommendation 4: Peak Hour Capacity Planning at Interchange Stations

**Finding:**
The PM peak (18:00–19:00) is the single busiest hour network-wide.
However, peak timing varies significantly by station type:

- **Benniganahalli and Krishnarajapura** (IT corridor): Sharp AM peak
  at 08:00–09:00, indicating office commuters
- **MG Road, Trinity, Cubbon Park** (commercial zone): PM peak at
  18:00–19:00, indicating retail and office evening rush
- **Kempegowda** (interchange): Sustained high load throughout the day
  with no single dominant peak

**Recommendation:**
Move away from a uniform peak hours policy. Implement station-specific
staffing and train holding schedules:

1. Deploy additional platform staff at IT corridor stations 07:45–09:30
2. Increase train dwell time at Kempegowda during 08:00–10:00 and
   17:00–19:30 to manage interchange passenger flow
3. Install dynamic crowd indicators at top 10 stations to enable
   real-time platform management

**Business impact:**
Reducing platform overcrowding at peak stations improves safety metrics
and passenger satisfaction scores — both tracked by BMRCL in their
annual performance review.

**Data evidence:**

- SQL Query: `04_advanced_analytics.sql` — rolling averages and rankings
- Chart: `04_hourly_heatmap.png`
- Power BI: Time Patterns page, hourly profile

---

## Recommendation 5: Proactive October 2025 Capacity Planning

**Finding:**
The Prophet forecasting model projects average daily network entries of
760,852 in October 2025 — a 7.9% increase over the Aug-Sep average of
704,956. This growth is driven by post-monsoon normalisation and the
return of regular office attendance after the Dussehra holiday week.

**Recommendation:**
Use the forecast to pre-position operational resources for October:

1. **Staffing:** Increase platform and security staff by 8% at top 10
   stations from October 1
2. **Train frequency:** Add one additional train per hour on Purple Line
   during 08:00–10:00 and 17:00–20:00 from October 6 (post-Dussehra)
3. **Maintenance scheduling:** Complete all planned maintenance by
   September 30 before the October demand surge
4. **Contingency planning:** Flag October 2 (Gandhi Jayanti) as a
   holiday in operational systems — our model shows holiday dips of
   35–40% below normal weekday levels

**Forecast details:**

- Projected Oct avg: 760,852 entries/day
- 95% confidence interval: ~650,000 to ~870,000 entries/day
- Model accuracy: 5.2% MAPE (cross-validated)
- Top station projection: Kempegowda at 33,938 entries/day

**Data evidence:**

- Notebook: `03_forecasting.ipynb`
- Chart: `08_network_forecast.png`, `10_station_forecasts.png`

---

## Summary Table

| #   | Recommendation               | Priority | Effort | Impact                |
| --- | ---------------------------- | -------- | ------ | --------------------- |
| 1   | Tiered service frequency     | High     | Medium | Cost reduction        |
| 2   | Yellow Line demand audit     | High     | Low    | Revenue growth        |
| 3   | Weekend revenue optimisation | Medium   | Low    | Revenue growth        |
| 4   | Peak hour capacity planning  | High     | Medium | Safety + satisfaction |
| 5   | October capacity planning    | Urgent   | Low    | Operational readiness |

---

## Methodology Notes

- Data covers Aug 1–18 and Sep 1–30, 2025 (49 unique days)
- Aug data is entry-only; Sep data includes entry and exit counts
- Forecasting model trained on 49 days — sufficient for weekly patterns
  but insufficient for yearly seasonality
- All revenue estimates use BMRCL's publicly reported average fare of ₹28
- Recommendations should be validated against BMRCL's internal ridership
  data before implementation

---

_This analysis was conducted as part of a portfolio project using real
BMRCL operational data. Recommendations are based on data patterns and
standard transit operations best practices._
