# Aggregations


### Top ten cities by incident count from 2014-2016


```sql
SELECT
  city,
  state,
  COUNT(*) AS incidents
FROM fatal_encounters
WHERE
  STRFTIME('%Y', date) IN ('2014', '2015', '2016')
GROUP BY city, state
ORDER BY incidents DESC
LIMIT 10;
```

| city          | state | incidents |
| ------------- | ----- | --------- |
| Houston       | TX    | 94        |
| Los Angeles   | CA    | 69        |
| Chicago       | IL    | 66        |
| Phoenix       | AZ    | 48        |
| San Antonio   | TX    | 47        |
| Dallas        | TX    | 41        |
| Las Vegas     | NV    | 30        |
| Detroit       | MI    | 29        |
| Oklahoma City | OK    | 28        |
| Albuquerque   | NM    | 26        |



### Top 20 cities by incident count per 100k capita from 2014-2016


~~~sql
WITH tx AS (
  SELECT 
    city
    , state
    , COUNT(*) AS incidentcount
  FROM fatal_encounters
  WHERE
      STRFTIME('%Y', date) BETWEEN '2014' AND '2016'
  GROUP BY 
    city, state
)

SELECT 
  tx.city
  , tx.state
  , tx.incidentcount 
  , ty.pop10 AS population
  , ROUND(100000.0 * incidentcount / ty.pop10, 2 ) 
           AS incidents_per_100k
FROM 
  tx
INNER JOIN
    census_places AS ty
    ON
       (tx.city || ' ' || 'city') = ty.name
       AND tx.state = ty.usps
WHERE 
  population > 100000
ORDER BY 
  incidents_per_100k DESC
LIMIT 20;
~~~

| city           | state | incidentcount | population | incidents_per_100k |
| -------------- | ----- | ------------- | ---------- | ------------------ |
| Waco           | TX    | 11            | 124805     | 8.81               |
| Orlando        | FL    | 17            | 238300     | 7.13               |
| Kansas City    | KS    | 10            | 145786     | 6.86               |
| Flint          | MI    | 7             | 102434     | 6.83               |
| San Bernardino | CA    | 14            | 209924     | 6.67               |
| St. Louis      | MO    | 21            | 319294     | 6.58               |
| Midland        | TX    | 7             | 111147     | 6.3                |
| Topeka         | KS    | 8             | 127473     | 6.28               |
| Stockton       | CA    | 18            | 291707     | 6.17               |
| Knoxville      | TN    | 11            | 178874     | 6.15               |
| Birmingham     | AL    | 13            | 212237     | 6.13               |
| Tulsa          | OK    | 24            | 391906     | 6.12               |
| Beaumont       | TX    | 7             | 118296     | 5.92               |
| Bakersfield    | CA    | 20            | 347483     | 5.76               |
| Baton Rouge    | LA    | 13            | 229493     | 5.66               |
| Pueblo         | CO    | 6             | 106595     | 5.63               |
| Huntsville     | AL    | 10            | 180105     | 5.55               |
| Modesto        | CA    | 11            | 201165     | 5.47               |
| Kansas City    | MO    | 25            | 459787     | 5.44               |
| Cincinnati     | OH    | 16            | 296943     | 5.39               |

