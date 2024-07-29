SELECT * FROM (
SELECT 
    *, 
    ROW_NUMBER() OVER (ORDER BY continent_code, median_gdp_per_capita) AS rowN 
FROM (
    SELECT 
      cm.continent_code, 
      pc.year, 
      SUM(pc.gdp_per_capita) AS median_gdp_per_capita
    FROM per_capita pc 
    INNER JOIN continent_map cm ON cm.country_code = pc.country_code 
    GROUP BY cm.continent_code, pc.year 
    ORDER BY cm.continent_code, median_gdp_per_capita
  )
) 
WHERE (rowN - 5) % 9 = 0;