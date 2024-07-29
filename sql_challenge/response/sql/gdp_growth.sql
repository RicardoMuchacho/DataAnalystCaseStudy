SELECT 
    pc.country_code, 
    c.country_name, 
    ((pc.gdp_per_capita - prev_pc.gdp_per_capita) / prev_pc.gdp_per_capita) * 100 AS gdp_growth_2011_2012
FROM per_capita pc
INNER JOIN 
    per_capita AS prev_pc 
    ON pc.country_code = prev_pc.country_code 
    AND pc.year = prev_pc.year + 1
INNER JOIN countries c ON c.country_code = pc.country_code
WHERE pc.year = 2011 OR pc.year = 2012
ORDER BY gdp_growth_2011_2012 DESC
LIMIT 10;