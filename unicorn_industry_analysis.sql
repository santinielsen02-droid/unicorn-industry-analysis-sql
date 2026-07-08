/*
====================================================
Project: Unicorn Industry Analysis (SQL)
Author: Santiago Nielsen
Database: PostgreSQL

Business Problem
----------------------------------------------------
A venture capital firm wants to identify the
top-performing industries based on the number of
unicorn companies created between 2019 and 2021.
The analysis also evaluates the average valuation
of these companies to support investment decisions.

Project Objectives
----------------------------------------------------
- Identify the top three unicorn industries
- Count unicorn companies by year
- Calculate average company valuation
- Convert valuations into billions of U.S. dollars
- Produce a business-ready report

SQL Skills Demonstrated
----------------------------------------------------
- Common Table Expressions (CTEs)
- INNER JOIN
- Aggregate Functions (COUNT, AVG)
- Date Functions (EXTRACT)
- Data Transformation
- REGEXP_REPLACE()
- GROUP BY
- ORDER BY
- LIMIT
- Business Analytics

====================================================
*/

WITH top_industries AS (
    SELECT
        industry,
        COUNT(*) AS num_unicorns
    FROM industries
    JOIN dates
        ON industries.company_id = dates.company_id
    WHERE EXTRACT(YEAR FROM date_joined) IN (2019, 2020, 2021)
    GROUP BY industry
    ORDER BY num_unicorns DESC
    LIMIT 3
),

industry_year_stats AS (
    SELECT
        industries.industry,
        EXTRACT(YEAR FROM dates.date_joined) AS year,
        COUNT(*) AS num_unicorns,

        ROUND(
            AVG(funding.valuation / 1000000000.0),
            2
        ) AS average_valuation_billions

    FROM top_industries

    JOIN industries
        ON top_industries.industry = industries.industry

    JOIN dates
        ON industries.company_id = dates.company_id

    JOIN funding
        ON industries.company_id = funding.company_id

    WHERE EXTRACT(YEAR FROM dates.date_joined) IN (2019, 2020, 2021)

    GROUP BY
        industries.industry,
        EXTRACT(YEAR FROM dates.date_joined)
)

SELECT *
FROM industry_year_stats
ORDER BY
    year DESC,
    num_unicorns DESC;