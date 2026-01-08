SELECT vendor, COUNT(*) as count_records,
       SUM(mis_county) AS mis_county,
       SUM(mis_dob) AS mis_dob,
       SUM(mis_ssn) AS mis_ssn,
       SUM(mis_disposition) as mis_disposition,
       AVG(latency_hour) as latency_hour,
       AVG(latency_minute) as latency_minute
 FROM {{ ref("miss_value_flag") }}
 GROUP BY vendor
 ORDER BY vendor