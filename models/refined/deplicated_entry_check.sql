SELECT record_id, vendor, county, dob, ssn, disposition, record_date, count(*) AS cnt
FROM {{ref("miss_value_flag")}}
GROUP BY record_id, vendor, county, dob, ssn, disposition, record_date
HAVING cnt > 1
