CREATE TABLE IF NOT EXISTS memory.default.orders AS
SELECT *, now() AS now
FROM tpch.sf100.orders
LIMIT 100000;
