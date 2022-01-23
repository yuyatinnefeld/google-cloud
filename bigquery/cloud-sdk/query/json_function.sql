-- read json as text

SELECT JSON_EXTRACT(json_text, '$') AS json_text_string
FROM UNNEST([
  '{"class" : {"students" : [{"name" : "Jane"}]}}',
  '{"class" : {"students" : [{"name" : "Maik"}, {"name": "Carlo"},{"name" : "Kim"}]}}',
  '{"class" : {"students" : [{"name" : "Anna"}, {"name": "Jamie"}]}}'
  ]) AS json_text;

-- first student
SELECT JSON_EXTRACT(json_text, '$.class.students[0]') AS first_student
FROM UNNEST([
  '{"class" : {"students" : [{"name" : "Jane"}]}}',
  '{"class" : {"students" : [{"name" : "Maik"}, {"name": "Carlo"},{"name" : "Kim"}]}}',
  '{"class" : {"students" : [{"name" : "Anna"}, {"name": "Jamie"}]}}'
  ]) AS json_text;


SELECT JSON_QUERY(json_text, '$.class.students[0]') AS first_student
FROM UNNEST([
  '{"class" : {"students" : [{"name" : "Jane"}]}}',
  '{"class" : {"students" : [{"name" : "Maik"}, {"name": "Carlo"},{"name" : "Kim"}]}}',
  '{"class" : {"students" : [{"name" : "Anna"}, {"name": "Jamie"}]}}'
  ]) AS json_text;


-- extract
SELECT JSON_EXTRACT('{"student": {"name": "world"}}', "$['student'].name") AS hola;
SELECT JSON_EXTRACT('{"fruits": ["apple", "banana"]}', '$.fruits[0]') AS json_extract

-- json query array
SELECT JSON_QUERY_ARRAY(
  '{"fruit":[{"apples":5,"oranges":10},{"apples":2,"oranges":4}],"vegetables":[{"lettuce":7,"kale": 8}]}',
  '$.fruit'
) AS string_array;

-- query to json
With CoordinatesTable AS (
    (SELECT 1 AS id, [10,20] AS coordinates) UNION ALL
    (SELECT 2 AS id, [30,40] AS coordinates) UNION ALL
    (SELECT 3 AS id, [50,60] AS coordinates))
SELECT id, coordinates, TO_JSON_STRING(t) AS json_data
FROM CoordinatesTable AS t;


With NameTable AS (
    (SELECT 1 AS id, "Nick" AS firstname, "Tomson" AS lastname ) UNION ALL
    (SELECT 2 AS id, "Kany" AS firstname, "Sanders" AS lastname ) UNION ALL
    (SELECT 3 AS id, "Tara" AS firstname, "Figers" AS lastname ))
SELECT id, firstname, lastname, TO_JSON_STRING(t) AS json_data
FROM NameTable AS t;
