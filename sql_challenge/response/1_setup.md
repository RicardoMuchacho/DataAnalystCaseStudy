1. **Setup:**
   - Create a SQL database using the provided CSV files.
   - Use this database to answer all questions.

## Response

For this exercise I chose to create a SQLite db since we're handling a small amount of data. The steps to create the database are as follows:

1. Open terminal and create database

sqlite3 countries.db

2. Create tables with corresponding .csv columns

sqlite> .schema
CREATE TABLE continent_map (country_code VARCHAR(3), continent_code VARCHAR(2));
CREATE TABLE continent(continent_code VARCHAR(2), continent_name TEXT);
CREATE TABLE countries(country_code VARCHAR(3), country_name TEXT);
CREATE TABLE per_capita(country_code VARCHAR(3), year INTEGER, gdp_per_capita REAL);

3. Import .csv data to corresponding tables

sqlite> .mode csv
sqlite> .import ./data/continent_map.csv continent_map
sqlite> .import ./data/continents.csv continents       
sqlite> .import ./data/countries.csv countries  
sqlite> .import ./data/per_capita.csv per_capita

4. Check data imported (repeat for each table)

sqlite> select * from continent_map limit 5; 