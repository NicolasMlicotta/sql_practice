-- ============================================
-- SQL PORTFOLIO – CONSULTAS AGRUPADAS POR TEMA
-- ============================================

-- US Housing Units
SELECT year, month, south AS "Sur", west AS "West"
FROM tutorial.us_housing_units
WHERE month = 12
LIMIT 10;

SELECT year, month, south AS "Sur", west AS "West", 
  (south + 10) AS month_plus_ten, 
  (south + west) / 2 AS south_west_avg
FROM tutorial.us_housing_units
WHERE month <> 12
LIMIT 10;

SELECT year, month, south, west, midwest, northeast
FROM tutorial.us_housing_units
WHERE west > (midwest + northeast);

-- Billboard Top 100
SELECT * FROM tutorial.billboard_top_100_year_end
ORDER BY year DESC, year_rank DESC;

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE artist ILIKE 'snoop%';

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year_rank IN (1, 2, 3);

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris');

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year_rank BETWEEN 5 AND 10;

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE artist IS NULL;

SELECT * FROM tutorial.billboard_top_100_year_end
WHERE year = 2012 AND year_rank NOT BETWEEN 2 AND 3;

-- Apple Historical Stock Price
SELECT COUNT(*) FROM tutorial.aapl_historical_stock_price;

SELECT SUM(volume) AS total_volume FROM tutorial.aapl_historical_stock_price;

SELECT MIN(volume), MAX(volume) FROM tutorial.aapl_historical_stock_price;

SELECT year, month, COUNT(*) AS count
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month;

SELECT year, month, MAX(high) AS month_high
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400;

-- CASE WHEN
SELECT player_name, year,
  CASE WHEN year = 'SR' THEN 'yes' ELSE 'no' END AS is_senior
FROM benn.college_football_players;

SELECT player_name, weight,
  CASE
    WHEN weight > 250 THEN 'over 250'
    WHEN weight > 200 THEN '201-250'
    WHEN weight > 175 THEN '176-200'
    ELSE '<=175'
  END AS weight_group
FROM benn.college_football_players;

-- JOINs
SELECT teams.conference, AVG(players.weight) AS avg_weight
FROM benn.college_football_players players
JOIN benn.college_football_teams teams
  ON teams.school_name = players.school_name
GROUP BY teams.conference
ORDER BY avg_weight DESC;

SELECT companies.permalink, companies.name, companies.status,
       COUNT(investments.investor_permalink) AS investors
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
  ON companies.permalink = investments.company_permalink
  AND investments.funded_year > companies.founded_year + 5
GROUP BY 1, 2, 3;

-- Fechas y casteos
SELECT companies.permalink,
       companies.founded_at_clean,
       acquisitions.acquired_at_cleaned,
       acquisitions.acquired_at_cleaned - companies.founded_at_clean::timestamp AS time_to_acquisition
FROM tutorial.crunchbase_companies_clean_date companies
JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
  ON acquisitions.company_permalink = companies.permalink
WHERE companies.founded_at_clean IS NOT NULL;

-- Funciones de texto
SELECT incidnt_num, date,
  LEFT(date, 10) AS cleaned_date,
  RIGHT(date, LENGTH(date) - 11) AS cleaned_time
FROM tutorial.sf_crime_incidents_2014_01;

SELECT location,
  TRIM(BOTH '()' FROM location) AS trimmed_location
FROM tutorial.sf_crime_incidents_2014_01;

SELECT incidnt_num, descript,
  STRPOS(descript, 'A') AS a_position
FROM tutorial.sf_crime_incidents_2014_01;

SELECT incidnt_num, day_of_week,
  CONCAT(day_of_week, ', ', LEFT(date, 10)) AS day_and_date
FROM tutorial.sf_crime_incidents_2014_01;

-- Funciones de fecha y hora
SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       NOW() AS now;

-- Subqueries
SELECT sub.*
FROM (
  SELECT * FROM tutorial.sf_crime_incidents_2014_01
  WHERE day_of_week = 'Friday'
) sub
WHERE sub.resolution = 'NONE';

SELECT *
FROM tutorial.sf_crime_incidents_2014_01
WHERE date IN (
  SELECT date
  FROM tutorial.sf_crime_incidents_2014_01
  ORDER BY date
  LIMIT 5
);

SELECT incidents.*, sub.incidents AS incidents_that_day
FROM tutorial.sf_crime_incidents_2014_01 incidents
JOIN (
  SELECT date, COUNT(incidnt_num) AS incidents
  FROM tutorial.sf_crime_incidents_2014_01
  GROUP BY date
) sub ON incidents.date = sub.date
ORDER BY sub.incidents DESC, time;

SELECT COUNT(*) AS total_rows
FROM (
  SELECT * FROM tutorial.crunchbase_investments_part1
  UNION ALL
  SELECT * FROM tutorial.crunchbase_investments_part2
) sub;

-- Funciones de ventana
SELECT duration_seconds,
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
FROM tutorial.dc_bikeshare_q1_2012;

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS running_total
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER (PARTITION BY start_terminal) AS running_total,
       COUNT(duration_seconds) OVER (PARTITION BY start_terminal) AS running_count,
       AVG(duration_seconds) OVER (PARTITION BY start_terminal) AS running_avg
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal,
       start_time,
       duration,
       ROW_NUMBER() OVER (ORDER BY start_time) AS row_number
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal,
       start_time,
       duration,
       ROW_NUMBER() OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_number
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal DESC, start_time DESC;

SELECT start_terminal, duration_seconds,
       RANK() OVER (PARTITION BY start_terminal ORDER BY start_time) AS rank
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal, duration_seconds,
       DENSE_RANK() OVER (PARTITION BY start_terminal ORDER BY start_time) AS rank
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

SELECT start_terminal, duration_seconds,
       NTILE(4) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quartile,
       NTILE(5) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS quintile,
       NTILE(100) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08' AND start_terminal = 31007;

-- LAG y LEAD
SELECT start_terminal, duration_seconds, 
       LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds;

-- Diferencia entre valores consecutivos
SELECT start_terminal, duration_seconds,
       duration_seconds - LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds;

-- Definición de ventana reutilizable
SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER ntile_window AS quartile,
       NTILE(5) OVER ntile_window AS quintile,
       NTILE(100) OVER ntile_window AS percentile
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW ntile_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY start_terminal, duration_seconds;
