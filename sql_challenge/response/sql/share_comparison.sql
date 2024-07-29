   SELECT continent_code, 
   (continent_gdp_per_capita / total_gdp) * 100 AS percentage_share
   FROM (
      SELECT
         cm.continent_code, 
         pc.year, 
         SUM(pc.gdp_per_capita) AS continent_gdp_per_capita,
         (  SELECT SUM(pc.gdp_per_capita)
            FROM per_capita pc
            WHERE pc.year = 2012
         ) AS total_gdp
      FROM per_capita pc 
      INNER JOIN continent_map cm ON cm.country_code = pc.country_code WHERE pc.year = 2012 
      GROUP BY cm.continent_code
   ) ORDER BY percentage_share DESC;




