# Sanity checks/scoping out the d

## Census places

### Top 10 places by population

~~~sql
SELECT geoid, usps, name, pop10
FROM census_places
ORDER BY pop10 DESC
LIMIT 10;
~~~

| GEOID   | USPS | NAME              | POP10   |
| ------- | ---- | ----------------- | ------- |
| 3651000 | NY   | New York city     | 8175133 |
| 0644000 | CA   | Los Angeles city  | 3792621 |
| 1714000 | IL   | Chicago city      | 2695598 |
| 4835000 | TX   | Houston city      | 2099451 |
| 4260000 | PA   | Philadelphia city | 1526006 |
| 0455000 | AZ   | Phoenix city      | 1445632 |
| 4865000 | TX   | San Antonio city  | 1327407 |
| 0666000 | CA   | San Diego city    | 1307402 |
| 4819000 | TX   | Dallas city       | 1197816 |
| 0668000 | CA   | San Jose city     | 945942  |


### Top 10 places by population density


~~~sql
SELECT geoid, usps, name, 
  pop10, aland_sqmi,
  ROUND(pop10 / aland_sqmi) AS pop_per_sq_mile
FROM census_places
ORDER BY pop_per_sq_mile DESC
LIMIT 10;
~~~

| GEOID   | USPS | NAME                           | POP10   | ALAND_SQMI | pop_per_sq_mile |
| ------- | ---- | ------------------------------ | ------- | ---------- | --------------- |
| 2430800 | MD   | Friendship Heights Village CDP | 4698    | 0.059      | 79627.0         |
| 3428650 | NJ   | Guttenberg town                | 11176   | 0.196      | 57020.0         |
| 3474630 | NJ   | Union City city                | 66455   | 1.283      | 51797.0         |
| 3479610 | NJ   | West New York town             | 49708   | 1.007      | 49362.0         |
| 3432250 | NJ   | Hoboken city                   | 50005   | 1.275      | 39220.0         |
| 3638934 | NY   | Kaser village                  | 4724    | 0.172      | 27465.0         |
| 3651000 | NY   | New York city                  | 8175133 | 302.643    | 27012.0         |
| 3413570 | NJ   | Cliffside Park borough         | 23594   | 0.963      | 24501.0         |
| 3419360 | NJ   | East Newark borough            | 2406    | 0.102      | 23588.0         |
| 0646492 | CA   | Maywood city                   | 27395   | 1.178      | 23256.0         |


## Agg counts

### Incidents by race

```sql
SELECT
  race,
  COUNT(*) AS c
FROM 
  fatal_encounters
GROUP BY race
ORDER BY c DESC;
```

### Incidents by state and year


```sql
SELECT 
  STRFTIME('%Y', date) as year,
  state,
  COUNT(*) AS ct
FROM 
  fatal_encounters
GROUP BY year, state
ORDER BY state ASC, year ASC;
```


### Incidents by disposition


```sql
SELECT
  official_disposition,
  COUNT(*) AS c
FROM 
  fatal_encounters
GROUP BY official_disposition
ORDER BY c DESC;
```



```sql
SELECT
  STRFTIME('%Y', date) as year,
  official_disposition,
  COUNT(*) AS c
FROM 
  fatal_encounters
WHERE
  official_disposition IN 
    ('Unreported', 'Pending investigation', 'Unknown')
GROUP BY year, official_disposition
ORDER BY year, official_disposition DESC;
```
