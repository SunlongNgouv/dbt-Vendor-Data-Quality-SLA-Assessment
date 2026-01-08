WITH data_scoring AS (
SELECT
      vendor,
      COUNT(*) AS total_records,
      -- 15% max. Coverage
      AVG(CASE WHEN dob IS NOT NULL THEN 1 ELSE 0 END) * 0.175 AS dob_completeness, -- completeness 0.35/2 = 0.175
      -- 35% max. PII Completeness
      AVG(CASE WHEN ssn IS NOT NULL THEN 1 ELSE 0 END) * 0.175 AS ssn_completeness, -- completeness 0.35/2 = 0.175
      -- 30% max. Disposition Accuracy
      AVG(CASE WHEN disposition IS NOT NULL THEN 1 ELSE 0 END) * 0.3 AS disposition_accuracy,
      -- 20% max. Freshness
      (SUM(CASE WHEN CAST(ingest_time AS TIMESTAMP) <= CAST(record_date AS TIMESTAMP) + INTERVAL '24 hours' THEN 1 ELSE 0 END)*1.0/COUNT(*)) * 0.2 AS freshness_score
      -- Data Quality Score = 35% PII Completeness + 30% Disposition Accuracy + 20% Freshness + 15% Coverage
FROM {{ ref("miss_value_flag") }}
GROUP BY vendor
ORDER BY vendor)

SELECT (dob_completeness + ssn_completeness + disposition_accuracy + freshness_score) AS data_qual_score, *
FROM data_scoring