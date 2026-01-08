SELECT vendor, record_id, latency_hour
FROM {{ ref("miss_value_flag") }}
WHERE latency_hour > 24