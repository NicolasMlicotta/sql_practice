# SQL Learning & Practice

Este repositorio contiene ejemplos y consultas SQL aplicadas sobre datasets públicos con fines de aprendizaje. Se abordan conceptos clave como filtros, agregaciones, joins, subqueries, manejo de fechas, limpieza de strings y más.

## Estructura

- `sql_practice.sql`: archivo con todas las consultas, organizadas por tema y dataset, con comentarios explicativos.

## Temas cubiertos

- SELECT, WHERE, ORDER BY, LIMIT
- Operadores: IN, BETWEEN, NOT BETWEEN, LIKE, ILIKE, IS NULL
- Funciones de agregación: COUNT, SUM, AVG, MIN, MAX
- Agrupaciones y filtros: GROUP BY, HAVING
- CASE WHEN para lógica condicional
- JOINS: LEFT JOIN, INNER JOIN, self joins
- Subqueries: en FROM, WHERE y JOIN
- Uniones de tablas: UNION ALL
- Funciones de texto: LEFT, RIGHT, TRIM, STRPOS, SUBSTR, CONCAT
- Funciones de fecha y tiempo: CURRENT_DATE, CURRENT_TIME, NOW, aritmética con timestamps
- Limpieza y transformación de datos
- Funciones de ventana (window functions): 
  - ROW_NUMBER, RANK, DENSE_RANK, NTILE
  - SUM, COUNT, AVG con OVER()
  - LAG, LEAD
  - Uso de PARTITION BY, ORDER BY en ventanas
  - Definición de ventanas con WINDOW
  - Cálculo de diferencias entre registros consecutivos

## Datasets utilizados

- `tutorial.us_housing_units`
- `tutorial.billboard_top_100_year_end`
- `tutorial.aapl_historical_stock_price`
- `benn.college_football_players / teams`
- `tutorial.crunchbase_*`
- `tutorial.sf_crime_incidents_2014_01`

## Fuente

> Todos los ejercicios provienen del tutorial interactivo de SQL en Mode Analytics:  
> [https://mode.com/sql-tutorial](https://mode.com/sql-tutorial)

---

> Las consultas fueron probadas en entornos SQL de práctica como Mode Analytics y documentadas para referencia futura.
