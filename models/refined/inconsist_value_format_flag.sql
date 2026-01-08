SELECT vendor,
       -- record_id should start with A** or B**
       SUM(CASE WHEN REGEXP_MATCHES(record_id, '[A-B]*') THEN 0 ELSE 1 END) AS flag_id,
       -- vendor should be in (vendor A, vendor B)
       SUM(CASE WHEN REGEXP_MATCHES(vendor, '[A-B]$') THEN 0 ELSE 1 END) AS flag_vendor,
       -- county should be in the us only
       SUM(CASE WHEN county IN (SELECT county FROM {{ref("stg_county_usa")}}) THEN 0 ELSE 1 END) AS flag_county,
       -- dob format should be YYYY/MM/DD
       SUM(CASE WHEN REGEXP_MATCHES(CAST(dob AS VARCHAR), '[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN 0 ELSE 1 END) AS flag_dob,
       -- ssn format should be XXX-XXX-XXXX
       SUM(CASE WHEN REGEXP_MATCHES(ssn, '([0-9]{3}-[0-9]{2}-[0-9]{4})') THEN 0 ELSE 1 END) AS flag_ssn,
       -- disposition value should be in (Convicted, Dismissed, Pending)
       SUM(CASE WHEN disposition IN ('Convicted', 'Dismissed', 'Pending') THEN 0 ELSE 1 END) AS flag_disp,
       -- record_date and ingest_time: dates should be in TimeStamp
       SUM(CASE WHEN TRY_CAST(record_date AS TIMESTAMP) IS NOT NULL
           AND TRY_CAST(ingest_time AS TIMESTAMP) IS NOT NULL THEN 0 ELSE 1 END) AS flag_date

FROM {{ ref("miss_value_flag") }}
GROUP BY vendor
ORDER BY vendor