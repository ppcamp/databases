-- IF FAILS, try:
-- Log into each psql node, and enable the extension:
-- Ports
--   Coordinator: 5432
--   Worker 1: 5433
--   Worker 2: 5434
-- psql -h node-1 -p 5432 -U myuser -d mydb
-- psql -h node-2 -p 5432 -U myuser -d mydb
-- CREATE EXTENSION IF NOT EXISTS citus;

------------------------------------------------------------------------------------------------------------------------
-- On the coordinator node:

-- before adding the first worker node, tell future worker nodes how to reach the coordinator
SELECT citus_set_coordinator_host('citus', 5432);

-- add worker nodes
SELECT citus_add_node('node-1', 5432 );
SELECT citus_add_node('node-2', 5432 );


-- SELECT citus_remove_node('node-1', 5432);
SELECT * FROM citus_nodes;


-- rebalance the shards over the new worker nodes
SELECT rebalance_table_shards();


select * from pg_tables;

CREATE TABLE events (
  device_id bigint,
  event_id bigserial,
  event_time timestamptz default now(),
  data jsonb not null,
  PRIMARY KEY (device_id, event_id)
);

-- distribute the events table across shards placed locally or on the worker nodes
SELECT create_distributed_table('events', 'device_id');

-- insert some events
INSERT INTO events (device_id, data)
SELECT s % 100, ('{"measurement":'||random()||'}')::jsonb FROM generate_series(1,1000000) s;

-- get the last 3 events for device 1, routed to a single node
SELECT * FROM events WHERE device_id = 1 ORDER BY event_time DESC, event_id DESC LIMIT 3;

EXPLAIN (VERBOSE ON, ANALYZE,BUFFERS )
    SELECT
        *
    FROM events
    WHERE device_id = 1
    ORDER BY
        event_time DESC,
        event_id DESC
    LIMIT 3;

-- The explain output for the citus extension cannot be used into others tools
EXPLAIN (ANALYZE, BUFFERS)
    SELECT
        *
    FROM events
    WHERE device_id = 1
    ORDER BY
        event_time DESC,
        event_id DESC
    LIMIT 3;



CREATE TABLE devices (
  device_id bigint primary key,
  device_name text,
  device_type_id int
);
CREATE INDEX ON devices (device_type_id);

-- co-locate the devices table with the events table
SELECT create_distributed_table('devices', 'device_id', colocate_with := 'events');

-- insert device metadata
INSERT INTO devices (device_id, device_name, device_type_id)
SELECT s, 'device-'||s, 55 FROM generate_series(0, 99) s;

-- optionally: make sure the application can only insert events for a known device
ALTER TABLE events ADD CONSTRAINT device_id_fk
FOREIGN KEY (device_id) REFERENCES devices (device_id);

-- get the average measurement across all devices of type 55, parallelized across shards
SELECT avg((data->>'measurement')::double precision)
FROM events JOIN devices USING (device_id)
WHERE device_type_id = 55;

------------------------------------------------------------------------------------------------------------------------



