SELECT 
         COUNT(*) AS n_groups,
         CASE WHEN country_code = "" THEN "N/A" ELSE country_code END AS country_code 
      FROM continent_map 
      GROUP BY country_code having COUNT(*) > 1 
      ORDER BY 
      CASE WHEN country_code = "" THEN 0 ELSE 1 END, 
      CASE WHEN country_code = "N/A" THEN 0 ELSE 1 END; 