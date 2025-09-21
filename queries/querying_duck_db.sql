-- Create a DuckDB database and load a large CSV file into it, then perform a
-- query.
CREATE TABLE my_table AS SELECT * FROM 'large_file.csv';

select * from large_file where city = 'New York' order by age asc, score desc limit 10;
