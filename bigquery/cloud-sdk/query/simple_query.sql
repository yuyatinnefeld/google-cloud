-- create a example temp table

WITH Players AS
 (SELECT 'gorbie' as account, 29 as level UNION ALL
  SELECT 'junelyn', 2 UNION ALL
  SELECT 'corba', 43 UNION ALL
  SELECT 'jiji', 50)

SELECT * FROM Players

-- show avg level as sub query

WITH Players AS
 (SELECT 'gorbie' as account, 29 as level UNION ALL
  SELECT 'junelyn', 2 UNION ALL
  SELECT 'corba', 43 UNION ALL
  SELECT 'jiji', 50)

SELECT account, level, (SELECT AVG(level) FROM Players) AS avg_level
FROM Players;


WITH Players AS
 (SELECT 'gorbie' as account, 29 as level UNION ALL
  SELECT 'junelyn', 2 UNION ALL
  SELECT 'corba', 43 UNION ALL
  SELECT 'jiji', 50)

SELECT account, level, (level - SELECT AVG(level) FROM Players) AS diff
FROM Players;

-- Array

SELECT [1, 2, 3] as num_arr;

SELECT ["apple", "pear", "orange"] as fruit_arr;

SELECT [true, false, true] as bool_arr;

SELECT ARRAY<FLOAT64>[1, 2, 3] as floats;

SELECT GENERATE_ARRAY(1, 50, 2) AS odds;


WITH sequences AS
  (SELECT [0, 1, 1, 2, 3, 5] AS some_numbers
   UNION ALL SELECT [2, 4, 8, 16, 32] AS some_numbers
   UNION ALL SELECT [5, 10] AS some_numbers)
SELECT some_numbers,
       some_numbers[OFFSET(0)] AS offset_1,
       ARRAY_LENGTH(some_numbers) AS len
FROM sequences;

WITH sequences AS
  (SELECT 1 AS id, [0, 1, 1, 2, 3, 5] AS some_numbers
   UNION ALL SELECT 2 AS id, [2, 4, 8, 16, 32] AS some_numbers
   UNION ALL SELECT 3 AS id, [5, 10] AS some_numbers)
SELECT id, flattened_numbers
FROM sequences, sequences.some_numbers AS flattened_numbers;


WITH sequences AS
  (SELECT [0, 1, 1, 2, 3, 5] AS some_numbers
  UNION ALL SELECT [2, 4, 8, 16, 32] AS some_numbers
  UNION ALL SELECT [5, 10] AS some_numbers)
SELECT some_numbers,
  ARRAY(SELECT x * 2
        FROM UNNEST(some_numbers) AS x) AS doubled
FROM sequences;


WITH sequences AS
  (SELECT [0, 1, 1, 2, 3, 5] AS some_numbers
   UNION ALL SELECT [2, 4, 8, 16, 32] AS some_numbers
   UNION ALL SELECT [5, 10] AS some_numbers)
   
SELECT some_numbers,
  (SELECT SUM(x)
   FROM UNNEST(s.some_numbers) x) AS sums
FROM sequences s;

-- concat

SELECT CONCAT("firstname", " ", "secondname") as fullname;

With Employees AS
  (SELECT
    "John" AS first_name,
    "Doe" AS last_name
  UNION ALL
  SELECT
    "Jane" AS first_name,
    "Smith" AS last_name
  UNION ALL
  SELECT
    "Joe" AS first_name,
    "Jackson" AS last_name)

SELECT
  CONCAT(first_name, " ", last_name)
  AS full_name
FROM Employees;


-- extract

SELECT
  date,
  EXTRACT(ISOYEAR FROM date) AS isoyear,
  EXTRACT(ISOWEEK FROM date) AS isoweek,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(WEEK FROM date) AS week,
  EXTRACT(DAY FROM date) AS day
FROM UNNEST(GENERATE_DATE_ARRAY('2021-07-23', '2021-09-09')) AS date
ORDER BY date;

-- diff

SELECT 
  DATE_DIFF(DATE '2021-09-02', DATE '1987-09-15', DAY) AS days_diff,
  DATE_DIFF(DATE '2021-09-02', DATE '1987-09-15', WEEK) AS weeks_diff,
  DATE_DIFF(DATE '2021-09-02', DATE '1987-09-15', MONTH) AS months_diff;

-- date format

SELECT FORMAT_DATE("%b %Y", DATE "2028-12-25") AS formatted;
SELECT FORMAT_DATE("%x", DATE "2008-12-25") AS US_format;
SELECT PARSE_DATE("%x", "12/25/08") AS parsed;
SELECT PARSE_DATE("%Y%m%d", "20081225") AS parsed;

SELECT DATETIME(2021, 09, 02, 9, 44, 00) as datetime_ymdhms; #2021-09-02T09:44:00

-- time stamp
SELECT CURRENT_TIMESTAMP() as now;

-- case

WITH ServerState AS
 (SELECT 80 as CPU, "mapR server" as server  UNION ALL
  SELECT 72, "EDW server" UNION ALL
  SELECT 65, "Tableau server" UNION ALL
  SELECT 10, "Spark server" UNION ALL
  SELECT 20, "Kafka server")
SELECT CPU, server,
  CASE
    WHEN CPU > 75 THEN 'red'
    WHEN CPU > 50 THEN 'yellow'
    ELSE 'green'
  END
  AS state
FROM ServerState

-- pivot table

WITH Produce AS (
  SELECT 'Kale' as product, 51 as sales, 'Q1' as quarter UNION ALL
  SELECT 'Kale', 23, 'Q2' UNION ALL
  SELECT 'Kale', 45, 'Q3' UNION ALL
  SELECT 'Kale', 3, 'Q4' UNION ALL
  SELECT 'Apple', 77, 'Q1' UNION ALL
  SELECT 'Apple', 0, 'Q2' UNION ALL
  SELECT 'Apple', 25, 'Q3' UNION ALL
  SELECT 'Apple', 2, 'Q4')
SELECT * FROM Produce

SELECT * FROM
  (SELECT * FROM Produce)
  PIVOT(SUM(sales) FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4'))
