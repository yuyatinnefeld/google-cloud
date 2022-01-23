-- SQL UDFs 
CREATE TEMP FUNCTION Add(x INT64, y INT64)
  RETURNS FLOAT64
  AS (x + y);

CREATE TEMP FUNCTION Mul(x INT64, y INT64)
  RETURNS FLOAT64
  AS (x * y);

SELECT val, Add(val, 100), Mul(val, 2)
  FROM UNNEST([2,3,5,8]) AS val;


-- array UDF
CREATE TEMP FUNCTION lastArrayElement(arr ANY TYPE) AS (
  arr[ORDINAL(ARRAY_LENGTH(arr))]
);

SELECT lastArrayElement(x) as last_element
  FROM (SELECT [2,3,5,8,13] as x)

-- javascript UDF

CREATE TEMP FUNCTION multiplyInputs(x FLOAT64, y FLOAT64)
RETURNS FLOAT64
LANGUAGE js AS r"""
  return x*y;
""";

WITH numbers AS
  (SELECT 1 AS x, 5 as y
  UNION ALL
  SELECT 2 AS x, 10 as y
  UNION ALL
  SELECT 3 as x, 15 as y)
SELECT x, y, multiplyInputs(x, y) as product
FROM numbers;



CREATE TEMP FUNCTION customGreeting(a STRING)
RETURNS STRING
LANGUAGE js AS r"""
  var d = new Date();
  if (d.getHours() < 12) {
    return 'Good Morning, ' + a + '!';
  } else {
    return 'Good Evening, ' + a + '!';
  }
  """;
SELECT customGreeting(names) as everyone
FROM UNNEST(["Hannah", "Max", "Jakob"]) AS names;


CREATE FUNCTION ds_eu.multiply_by_three(x INT64) AS (x * 3);

SELECT my_dataset.multiply_by_three(5) AS result; -- returns 15

