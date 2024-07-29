2. **Questions:**

   1. **Data Cleanup:** List all country codes in the `continent_map` table that appear more than once, alphabetically. Display "N/A" for countries with no code first.

   Query: 
      SELECT 
         COUNT(*) AS n_groups,
         CASE WHEN country_code = "" THEN "N/A" ELSE country_code END AS country_code 
      FROM continent_map 
      GROUP BY country_code having COUNT(*) > 1 
      ORDER BY 
      CASE WHEN country_code = "" THEN 0 ELSE 1 END, 
      CASE WHEN country_code = "N/A" THEN 0 ELSE 1 END;  

      4|N/A
      3|ARM
      2|AZE
      2|CYP
      2|GEO
      2|KAZ
      2|RUS
      2|TUR
      2|UMI

      Note: getting the N/A first was the tricky part, tried using UNION, COALESCE and others, at the end the conditional ordering was the correct solution.

   2. **GDP Growth:** List the top 10 countries by year-over-year % GDP per capita growth from 2011 to 2012.

      Query:
      SELECT 
         pc.country_code, 
         c.country_name, 
         ((pc.gdp_per_capita - prev_pc.gdp_per_capita) / prev_pc.gdp_per_capita) * 100 AS gdp_growth_2011_2012
      FROM per_capita pc
      JOIN 
         per_capita AS prev_pc 
         ON pc.country_code = prev_pc.country_code 
         AND pc.year = prev_pc.year + 1
      JOIN countries c ON c.country_code = pc.country_code
      WHERE pc.year = 2011 OR pc.year = 2012
      ORDER BY gdp_growth_2011_2012 DESC;

      MNG|Mongolia|39.177513345642
      ETH|Ethiopia|35.8751718400144
      GNQ|Equatorial Guinea|33.2751845752529
      MOZ|Mozambique|32.1313085547415
      IRQ|Iraq|30.501685494294
      BRN|Brunei Darussalam|30.3233885581678
      TKM|Turkmenistan|30.3188486730226
      KWT|Kuwait|28.2012899282456
      PNG|Papua New Guinea|27.8621462694182
      KGZ|Kyrgyz Republic|27.7305032666183

      Note: getting the value from the previous year was the most complicated part in this exercise.

   3. **GDP Share Comparison:** For 2012, compare the GDP per capita percentage share for North America, Europe, and the Rest of the World.

   Query: 

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

    EU|39.0956327400211
    AS|24.6278432393008
    NA|12.4139101202041
    OC|4.93416933409843
    AF|4.64866827568152
    SA|3.47452361534968

   Note: Ideally I would declare variables like total_gdp at the beguinning making the query simpler but this is not allowed in sqlite. Tried to make a group with Rest of World countries using a CASE to exclude EU and NA but didn't work, I'll continue the quiz and return to this later if I have time.

   4. **Average GDP:** Calculate the average GDP per capita for each continent from 2004 to 2012.

     Query: 
     
      SELECT 
        cm.continent_code, 
        AVG(pc.gdp_per_capita) AS average_gdp 
      FROM per_capita pc
      INNER JOIN continent_map cm ON cm.country_code = pc.country_code
      GROUP BY cm.continent_code
      LIMIT 6;


      AF|2195.29895590864
      AS|11597.0411514834
      EU|27650.4858721177
      NA|14638.9356227712
      OC|8626.32201868632
      SA|5948.24044553241

   5. **Median GDP:** Calculate the median GDP per capita for each continent from 2004 to 2012.

   Query: 

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
    WHERE (rowN - 5) % 9 = 0

    AF|2010|122230.260448|5
    AS|2007|549535.4675885|14
    EU|2011|1408580.803772|23
    NA|2006|395419.5198723|32
    OC|2007|107200.3807356|41
    SA|2009|74829.452371|50

   Notes: 

   It would be better to make a solution that involves getting the middle value of odd and even total continent rows. Since there are 9 records for each continent I decided to implement a simpler solution

   Select COUNT(distinct country_code) from per_capita; //232
   Select count(distinct country_code) from continent_map; //252

   There are 20 country_codes without gdp in the continent_map table. They will not be considered for the gdp analysis