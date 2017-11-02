# Joining census and fatal encounter data



## Zip code

### Listing encounters by zip code with Census population

```sql
SELECT
    f.city,
    f.county,
    f.state,
    f.zip_code,
    STRFTIME('%Y', f.date) AS year,
    z.pop10 AS population
FROM fatal_encounters AS f
INNER JOIN
    census_zctas AS z
    ON z.geoid = f.zip_code;

```

### 2016 police shootings per 100k capita, by zipcode

(not very compelling as many zipcodes are too small to have more than 1 or more incidents)


```sql
SELECT
   ze.year
   , ze.state
   , ze.zip_code
   , ze.encounters
   , census_zctas.pop10  
        AS population_census_2010
   , ROUND(100000 * ze.encounters / census_zctas.pop10, 1) 
        AS encounters_per_100k
FROM (
        SELECT
            '2016' AS year
            , state
            , zip_code
            , COUNT(*) AS encounters
        FROM fatal_encounters
        WHERE 
          STRFTIME('%Y', date) = '2016'
        GROUP BY 
          state, zip_code
      ) AS ze

INNER JOIN census_zctas
  ON census_zctas.geoid = ze.zip_code

WHERE 
  population_census_2010 > 1000

ORDER BY 
  encounters_per_100k DESC;
```




## Place



