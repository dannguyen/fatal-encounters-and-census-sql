# Studying police-involved homicides and census data with SQLite

This repo contains data from the [Fatal Encounters](http://www.fatalencounters.org/) project and [Census 2010 Gazetteer](https://www.census.gov/geo/maps-data/data/gazetteer2010.html) -- and the code to bootstrap the data into a SQLite database.

The purpose is to provide an example of using SQL joins and aggregations to efficiently summarize and analyze real-world data. The Fatal Encounters data is a little "messy" because it is hand-entered by volunteers, but we can still use SQL to quickly do interesting and wide-scale explorations that would be very difficult with spreadsheet/pivot tables alone. Particularly, the joining of Census data with the city/state information in FE.

You can download the SQLite database here:

[fatal-encounters-and-census-2010.sqlite](https://github.com/dannguyen/fatal-encounters-and-census-sql/raw/master/fatal-encounters-and-census-2010.sqlite)

Special thanks to [D. Brian Burghart](http://www.fatalencounters.org/about-me/) and the many volunteers who continue to keep the Fatal Encounters project updated.  



# Sources

## Fatal Encounters

The longest-running crowdsourced project to track police-involved homicides in the U.S., with volunteer-researched data as far back as 2000:

[Fatal Encounters homepage](http://www.fatalencounters.org/)

[The Google Spreadsheet](https://docs.google.com/spreadsheets/d/1dKmaV_JiWcG8XBoRgP8b4e9Eopkpgt7FL7nyspvzAsE/edit#gid=0  )

## Census Gazetteer for 2010

The Gazetteer provides an easy-to-download flat (CSV) file of basic Census data by geographical regions. Very useful when all you care about is population by county, zip code, state, etc.

https://www.census.gov/geo/maps-data/data/gazetteer2010.html

Files:

- Zip codes (aka ZCTAs): http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_zcta_national.zip
- Places (e.g. cities): http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_places_national.zip
- Counties: http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_counties_national.zip


# SQL examples

TK: writing a few in the [examples folder](examples/)

But here's a few obvious ones:

###### Incident count by year

~~~sql
SELECT
  STRFTIME('%Y', date) as year,
  COUNT(*) AS incidentcount
FROM 
  fatal_encounters
GROUP BY year
ORDER BY year ASC;
~~~

| year | incidentcount |
| ---- | ------------- |
| 2000 | 817           |
| 2001 | 922           |
| 2002 | 986           |
| 2003 | 1057          |
| 2004 | 1041          |
| 2005 | 1153          |
| 2006 | 1263          |
| 2007 | 1255          |
| 2008 | 1210          |
| 2009 | 1242          |
| 2010 | 1268          |
| 2011 | 1393          |
| 2012 | 1465          |
| 2013 | 1780          |
| 2014 | 1715          |
| 2015 | 1590          |
| 2016 | 1578          |
| 2017 | 1459          |


###### Incident count by race


~~~sql
SELECT
  race,
  COUNT(*) AS incidentcount
FROM 
  fatal_encounters
GROUP BY race
ORDER BY incidentcount DESC;
~~~

| race                    | incidentcount |
| ----------------------- | ------------- |
| Race unspecified        | 9239          |
| European-American/White | 6294          |
| African-American/Black  | 4451          |
| Hispanic/Latino         | 2667          |
| Asian/Pacific Islander  | 307           |
| Native American/Alaskan | 200           |
| Middle Eastern          | 36            |



###### Top ten cities by incident total from 2014-2016


~~~sql
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
~~~

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


###### Top 20 cities by 2014-2016 incidents per 100k population


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




# Related reading


GQ Magazine: [Meet the Man Who Spends 10 Hours a Day Tracking Police Shootings](https://www.gq.com/story/fatal-encounters-police-statistics-interview)

> (emphasis added)

> In 2012, I was the editor of a newspaper. I was driving home from work and I came across this scene of chaos. There were more police cars there than I had ever seen. I realized that either a cop had just killed somebody, or somebody killed a cop.

> It was a Friday night and I just came home and I sat down, and I just tried to figure out how often that happens. So I looked at the FBI, and they have a number that they release every year called “justifiable homicides.”

> **It said that there were about 400 killings a year of people by police. But I just wanted to drill down into that data**. And I went straight to Florida, because Florida has a bit of a reputation [of police shootings.] And I figured that those numbers would be high. **And yet, according to the FBI, there had never been a person killed by police in the state of Florida.**

> **I realized, at that moment, that the whole thing was kind of a lie.**



Reddit IAMA: [I’m D. Brian Burghart, a journalist who was offended by the government’s lack of statistics on police-involved deaths, so I started the Fatal Encounters website. AMA!](https://www.reddit.com/r/IAmA/comments/2eyrdz/im_d_brian_burghart_a_journalist_who_was_offended/)
