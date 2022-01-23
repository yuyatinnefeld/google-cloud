-- NESTED TYPE - INTEGER [0,5,10,15,....]
SELECT GENERATE_ARRAY(0, 100, 5) AS example_array;


-- NESTED TYPE - Timestamp
SELECT GENERATE_DATE_ARRAY('2021-08-25',
  '2021-08-20', INTERVAL -1 DAY) AS example;

SELECT GENERATE_TIMESTAMP_ARRAY('2021-10-05 00:00:00', '2021-10-07 00:00:00',
                                INTERVAL 1 DAY) AS timestamp_array;

-- NESTED TYPE - STRING
SELECT ['Xbox One', 'Xbox Series X', 'Xbox Series S'] AS xbox_series;

WITH xbox_series AS (
  SELECT ['Xbox One', 'Xbox Series X', 'Xbox Series S'] AS console_name
)
SELECT * FROM xbox_series;

-- NESTED TYPE - STRING UNION
WITH all_games AS
  (SELECT ['Xbox One', 'Xbox Series X', 'Xbox Series S'] as list
  UNION ALL
  SELECT ['Wii U', 'Nintendo Switch', 'Nintendo Switch Lite'] as list
  UNION ALL
  SELECT ['Playstation 3', 'Playstation 4', 'Playstation 5'] as list)


SELECT list[OFFSET(0)] as serie1, list[OFFSET(1)] as serie2, list[OFFSET(2)] as serie3 FROM all_games;

-- NESTED TYPE - STRING UNION
WITH all_games AS
  (SELECT ['Xbox One', 'Xbox Series X', 'Xbox Series S'] as list
  UNION ALL
  SELECT ['Wii U', 'Nintendo Switch', 'Nintendo Switch Lite'] as list
  UNION ALL
  SELECT ['Playstation 3', 'Playstation 4', 'Playstation 5'] as list)

SELECT list, list[OFFSET(1)] as offset_1, list[ORDINAL(1)] as ordinal_1
FROM all_games;


-- UNNEST TYPE - STRING
SELECT fruit FROM UNNEST(["apple", "banana", "pear"]) as fruit;