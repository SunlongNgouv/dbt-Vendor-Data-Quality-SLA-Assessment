SELECT vendor, count(*) as total_records,
       SUM(CASE WHEN CAST(ingest_time AS TIMESTAMP) <= CAST(record_date AS TIMESTAMP) + INTERVAL '24 hours' THEN 1 ELSE 0 END) AS within_sla,
       SUM(CASE WHEN CAST(ingest_time AS TIMESTAMP) > CAST(record_date AS TIMESTAMP) + INTERVAL '24 hours' THEN 1 ELSE 0 END) AS out_of_sla
FROM {{ref("miss_value_flag")}}
GROUP BY vendor
ORDER BY vendor