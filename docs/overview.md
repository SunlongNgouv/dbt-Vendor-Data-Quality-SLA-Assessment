{% docs __overview__ %}

## Vendor Data Quality & SLA Monitoring Framework
#### 📌 Project Overview

This project demonstrates a lightweight, scalable framework for evaluating and monitoring third-party data vendors using standardized data quality metrics, SLA monitoring, and side-by-side vendor bake-offs.

The goal is to enable data-driven vendor decisions, improve downstream reliability, and maintain a clear audit trail for compliance and internal transparency.

#### 🎯 Objectives

1. Define a clear, measurable definition of Data Quality
2. Compare multiple vendors using quantitative bake-off metrics
3. Monitor SLA performance and identify breaches early
4. Translate business requirements into technical evaluation logic
5. Provide transparent documentation for audits and stakeholder alignment

#### ⚡ Quick Run
````
Prerequisites
- Python 3.9+ to 3.12 (dbt model doesn't support new python package)

To check your current python version: > python --version

1. Install dependencies: > pip install dbt-core dbt-duckdb

2. Load seed data: > dbt seed

3. Build models: > dbt run

4. Run data quality tests: > dbt test

5. Generate and view documentation:
> dbt docs generate\
> dbt docs serve

Open your browser at: http://localhost:8080
````

#### 🗂️ Project Structure
````
vendor_data_sla_dbt/
├── analyses/
├── docs/
│   ├── overview.md
├── logs/
│   ├── dbt.log
├── macros/
├── models/
│   ├── refined
│   │   ├── cross_columns_logic_flag.sql
│   │   ├── data_qual_scoring.sql
│   │   ├── deplicated_entry_check.sql
│   │   ├── inconsist_value_format_flag.sql
│   │   ├── is_within_sla.sql
│   │   ├── list_not_sla_24h.sql
│   │   ├── miss_value_count.sql
│   │   ├── miss_value_flag.sql
│   │   ├── sla_breach.sql
│   │   ├── ssn_record_id_map.sql
│   │   ├── vendors_db.sql
│   ├── stagging
│   │   ├── stg_county_usa.sql
│   │   ├── stg_vendor_a.sql
│   │   ├── stg_vendor_b.sql
│   ├── schema.yml
├── output/
├── seeds/
│   ├── .gitkeep
│   ├── united-states.csv
│   ├── vendor_a.csv
│   ├── vendor_b.csv
├── snapshots
│   ├── .gitkeep
│   ├── Screenshot 2026-01-07 234237.png
├── target
├── tests
├── README.md
````

#### 📊 Data Model (Mock Vendor Records)

Each vendor provides criminal record-like datasets with the following schema:

| Column      | Description                  |
| ----------- | ---------------------------- |
| record_id   | Unique record identifier     |
| vendor      | Data provider name           |
| county      | Jurisdiction                 |
| dob         | Date of birth (PII)          |
| ssn         | Social Security Number (PII) |
| disposition | Case outcome                 |
| record_date | Source record timestamp      |
| ingest_time | Time data was ingested       |


Mock data intentionally includes:
- Missing PII
- Delayed ingestion
- Inconsistent dispositions between vendors
- This simulates real-world vendor data variability.

#### 🧮 Defining Data Quality
1. Data Quality Dimensions\
Data quality is defined across four weighted dimensions:
- PII Completeness
- Presence of DOB and SSN
- Disposition Accuracy
- Valid and interpretable case outcomes

2. Freshness (Latency)\
Time difference between record date and ingestion

4. Coverage\
Jurisdictional availability

##### Weighted Scoring Model
Data Quality Score =
> 35% PII Completeness + 
> 30% Disposition Accuracy + 
> 20% Freshness + 
> 15% Coverage


Weights can be adjusted based on jurisdiction risk, compliance requirements, or downstream product sensitivity.

{% enddocs %}