-- Configure Cassandra catalog for this Thrift session
SET spark.sql.catalog.cassandra = com.datastax.spark.connector.datasource.CassandraCatalog;
SET spark.sql.catalog.cassandra.spark.cassandra.connection.host = cassandra100,cassandra101,cassandra102,cassandra110,cassandra200,cassandra201;
SET spark.sql.catalog.cassandra.spark.cassandra.connection.port = 9042;
SET spark.sql.catalog.cassandra.spark.cassandra.connection.localDC = US_EAST;
SET spark.sql.catalog.cassandra.spark.cassandra.read.timeout_ms = 120000;
SET spark.sql.catalog.cassandra.spark.cassandra.connection.keepAliveMS = 120000;

-- Explore using Hive-friendly syntax
SHOW SCHEMAS FROM cassandra;
SHOW TABLES FROM cassandra.mydb;

-- Query the Cassandra table
SELECT id, first_name, last_name, email
FROM cassandra.mydb.users
LIMIT 10;

-- Fallback if the catalog name isn't recognized in your session:
-- create a temp view using the connector and query it
CREATE OR REPLACE TEMP VIEW users_v
USING org.apache.spark.sql.cassandra
OPTIONS (keyspace 'mydb', table 'users');

SELECT id, first_name, last_name, email FROM users_v LIMIT 10;