SELECT *,
    (DATEDIFF('year', CAST(dob AS DATE), current_date) - CASE WHEN
       (DATE_PART('month', current_date), DATE_PART('day', current_date)) <
       (DATE_PART('month', CAST(dob AS DATE)), DATE_PART('day', CAST(dob AS DATE)))
       THEN 1 ELSE 0 END) AS age,
    (CASE WHEN NULLIF(NULLIF(county,''),'NaN') IS NULL THEN 1 ELSE 0 END) AS mis_county,
    (CASE WHEN NULLIF(NULLIF(CAST(dob AS VARCHAR),''),'NaN') IS NULL THEN 1 ELSE 0 END) AS mis_dob,
    (CASE WHEN NULLIF(NULLIF(ssn,''),'NaN') IS NULL THEN 1 ELSE 0 END) AS mis_ssn,
    (CASE WHEN NULLIF(NULLIF(disposition,''),'NaN') IS NULL THEN 1 ELSE 0 END) as mis_disposition,
    (DATEDIFF('hour', CAST(record_date AS TIMESTAMP), CAST(ingest_time AS TIMESTAMP))) as latency_hour,
    (DATEDIFF('minute', CAST(record_date AS TIMESTAMP), CAST(ingest_time AS TIMESTAMP))) as latency_minute
FROM {{ ref("vendors_db") }}