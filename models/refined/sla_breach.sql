CREATE SEQUENCE IF NOT EXISTS breach_seq START 1;

-- Create a new table to store SLA Breach Log
CREATE TABLE IF NOT EXISTS sla_breach_log(
    breach_id INT DEFAULT nextval('breach_seq') PRIMARY KEY,
    vendor VARCHAR(100),
    record_id VARCHAR(100),
    latency_hour INT,
    breach_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    alert TINYINT DEFAULT 0
)