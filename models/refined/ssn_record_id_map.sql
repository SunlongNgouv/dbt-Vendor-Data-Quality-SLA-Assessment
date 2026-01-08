SELECT ssn, COUNT(record_id) as count_id
FROM {{ ref("miss_value_flag") }}
GROUP BY ssn
HAVING count_id > 1
ORDER BY ssn