SELECT vendor,
       -- dates in ingest_time should be later than the dates in 'record_date'
       SUM(CASE WHEN record_date < ingest_time THEN 0 ELSE 1 END) AS c_rec_ing_flag,
       -- if disposition is not null, record_date should be not null
       SUM(CASE WHEN disposition IS NOT NULL AND
                     record_date IS NOT NULL THEN 0 ELSE 1 END) AS c_dis_rec_flag,
       -- if disposition is 'pending', record_date should be less than 30 days of ingest_time
       SUM(CASE WHEN disposition = 'Pending' AND
                     DATEDIFF('day', CAST(record_date AS TIMESTAMP),CAST(ingest_time AS TIMESTAMP)) > 30 THEN 1 ELSE 0 END) AS c_pending_30_flag,
       -- convicted records should have ssn
       SUM(CASE WHEN disposition = 'Convicted' AND
                     ssn IS NULL THEN 1 ELSE 0 END) AS c_con_ssn_flag,
       -- age should be reasonable with under 100 years old
       SUM(CASE WHEN age < 100 THEN 0 ELSE 1 END) AS c_age_flag,
       -- date of birth should be earlier than record_date
       SUM(CASE WHEN (DATE_PART('year', CAST(dob AS DATE))) <
              (DATE_PART('year', CAST(record_date AS DATE))) THEN 0 ELSE 1 END) AS c_dob_rec_flag,
       -- ingest_time should be within SLA at 48 hours from record_date
       SUM(CASE WHEN CAST(ingest_time AS DATE) <= CAST(record_date AS DATE) + INTERVAL '48 hours' THEN 0 ELSE 1 END) AS c_sla_48_flag

FROM {{ ref("miss_value_flag") }}
GROUP BY vendor
ORDER BY vendor