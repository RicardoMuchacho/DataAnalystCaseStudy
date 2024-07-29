## Visualization Challenge

This part assesses how you communicate your findings to stakeholders.

### Instructions

- Visualize the results from questions 3, 4, and 5 of the SQL Challenge.
- You can use any tool like Excel, Google Sheets, or Jupyter notebooks.
- Clearly label your datasets and provide the resulting file or links in the `viz_challenge` directory.

## SQL Challenge Data

   3. **GDP Share Comparison:** For 2012, compare the GDP per capita percentage share for North America, Europe, and the Rest of the World.

   Query: 

   SELECT *, 
   (continent_gdp_per_capita / total_gdp) * 100 AS percentage_share
   FROM (
         cm.continent_code, 
         pc.year, 
         SUM(pc.gdp_per_capita) AS continent_gdp_per_capita,
         SELECT * FROM  (
            SELECT SUM(pc.gdp_per_capita) AS total_gdp
            FROM per_capita pc
            WHERE pc.year = 2012
         ) AS total_gdp
      FROM per_capita pc 
      INNER JOIN continent_map cm ON cm.country_code = pc.country_code WHERE pc.year = 2012 
      GROUP BY cm.continent_code
   ) ORDER BY percentage_share DESC;

   EU|2012|1182753.247607|39.0956327400211
   AS|2012|745061.7762485|24.6278432393008
   NA|2012|375555.8225086|12.4139101202041
   OC|2012|149272.550286|4.93416933409843
   AF|2012|140635.3373706|4.64866827568152
   SA|2012|105114.147078|3.47452361534968

   Note: Ideally I would declare variables like total_gdp at the beguinning making the query simpler but this is not allowed in sqlite. Tried to make a group with Rest of World countries using a CASE to exclude EU and NA but didn't work, I'll continue the quiz and return to this later if I have time.

   4. **Average GDP:** Calculate the average GDP per capita for each continent from 2004 to 2012.

     Query: 
     SELECT cm.continent_code, AVG(pc.gdp_per_capita) AS average_gdp FROM per_capita pc INNER JOIN continent_map cm ON cm.country_code = pc.country_code GROUP BY cm.continent_code;

      AF|2195.29895590864
      AS|11597.0411514834
      EU|27650.4858721177
      NA|14638.9356227712
      OC|8626.32201868632
      SA|5948.24044553241
      continent_code|0.0

   5. **Median GDP:** Calculate the median GDP per capita for each continent from 2004 to 2012.

   Query: 
      SELECT * FROM (
      SELECT 
         *, 
         ROW_NUMBER() OVER (ORDER BY continent_code, continent_gdp_per_capita) AS rowN 
      FROM (
         SELECT 
            cm.continent_code, 
            pc.year, 
            SUM(pc.gdp_per_capita) AS continent_gdp_per_capita 
         FROM per_capita pc 
         INNER JOIN continent_map cm ON cm.country_code = pc.country_code 
         GROUP BY cm.continent_code, pc.year 
         ORDER BY cm.continent_code, continent_gdp_per_capita
      )
      ) 
      WHERE rowN % 5 = 0 
      AND continent_gdp_per_capita != 0.0;

      AF|2010|122230.260448|5
      AS|2004|391598.9422951|10
      AS|2010|610132.0168811|15
      EU|2004|1227859.7362231|20
      EU|2009|1447015.869284|25
      NA|2012|375555.8225086|30
      NA|2007|430591.1518505|35
      OC|2009|103764.59827|40
      OC|2012|149272.550286|45
      SA|2009|74829.452371|50
