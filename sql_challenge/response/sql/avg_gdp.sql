SELECT 
  cm.continent_code, 
  AVG(pc.gdp_per_capita) AS average_gdp 
FROM per_capita pc
INNER JOIN continent_map cm ON cm.country_code = pc.country_code
GROUP BY cm.continent_code
ORDER BY average_gdp DESC
LIMIT 6;
