# Studying police-involved homicides and census data with SQLite

This repo contains data from the [Fatal Encounters](http://www.fatalencounters.org/) project and [Census 2010 Gazetteer](https://www.census.gov/geo/maps-data/data/gazetteer2010.html) -- and the code to bootstrap the data into a SQLite database.

The purpose is to provide an example of how to use SQL joins and aggregations to efficiently summarize and analyze real-world data. Even when the data is as "messy" (I prefer "complicated") as it is from the FE project, because of the manual, decentralized, and crowdsourced data-collection process.

But we can still use SQL to quickly do interesting and wide-scale explorations that would be very difficult with spreadsheet/pivot tables alone. Particularly, the joining of FE data with an entirely different, and more formal dataset: the Census 2010 Gazetteer.

**Example:** Of the American cities with greater than 100,000 population, which of these cities have the highest count of police-involved homicides, from 2014-2016, when adjusted for population?

[Here's the SQL and resulting table](#top-20-cities-by-incident-per-100k).



Contrast that with the SQL and table for [top 20 cities by total count of incidents](#top-20-cities-by-incident-count-per-100k) (not adjusted for city population):

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
| Kansas City   | MO    | 25        |
| Tulsa         | OK    | 24        |
| San Francisco | CA    | 23        |
| Indianapolis  | IN    | 23        |
| Omaha         | NE    | 22        |
| Austin        | TX    | 22        |
| Washington    | DC    | 21        |
| St. Louis     | MO    | 21        |
| Tucson        | AZ    | 20        |
| Bakersfield   | CA    | 20        |






## The data

**You can download the SQLite database here:** [fatal-encounters-and-census-2010.sqlite](https://github.com/dannguyen/fatal-encounters-and-census-sql/raw/master/fatal-encounters-and-census-2010.sqlite)


The [data/](data/) folder contains copies of the source data files. Look at [bootstrap.sh](bootstrap.sh) and [schemas.sql](schemas.sql) if you're interested in how it was wrangled (requires [csvkit](http://csvkit.readthedocs.io/) and bash and gnu tols)




## Sources

Special thanks to [D. Brian Burghart](http://www.fatalencounters.org/about-me/) and the many volunteers who continue to keep the Fatal Encounters project updated.  


### Fatal Encounters

The longest-running crowdsourced project to track police-involved homicides in the U.S., with volunteer-researched data as far back as 2000:

[Fatal Encounters homepage](http://www.fatalencounters.org/)

[The Google Spreadsheet](https://docs.google.com/spreadsheets/d/1dKmaV_JiWcG8XBoRgP8b4e9Eopkpgt7FL7nyspvzAsE/edit#gid=0  )

### Census Gazetteer for 2010

The Gazetteer provides an easy-to-download flat (CSV) file of basic Census data by geographical regions. Very useful when all you care about is population by county, zip code, state, etc.

https://www.census.gov/geo/maps-data/data/gazetteer2010.html

Files:

- Zip codes (aka ZCTAs): http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_zcta_national.zip
- Places (e.g. cities): http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_places_national.zip
- Counties: http://www2.census.gov/geo/docs/maps-data/data/gazetteer/Gaz_counties_national.zip


## SQL examples

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


<a id="top-20-cities-by-incident-count" name="top-20-cities-by-incident-count"></a>

###### Top 20 cities by incident total from 2014-2016




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
LIMIT 20;
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
| Kansas City   | MO    | 25        |
| Tulsa         | OK    | 24        |
| San Francisco | CA    | 23        |
| Indianapolis  | IN    | 23        |
| Omaha         | NE    | 22        |
| Austin        | TX    | 22        |
| Washington    | DC    | 21        |
| St. Louis     | MO    | 21        |
| Tucson        | AZ    | 20        |
| Bakersfield   | CA    | 20        |


<a id="top-20-cities-by-incident-count-per-100k" name="top-20-cities-by-incident-count-per-100k"></a>


###### Top 20 cities by 2014-2016 incidents per 100k population


~~~sql
WITH tx AS (
  SELECT 
    city
    , state
    , COUNT(*) AS incidents
  FROM fatal_encounters
  WHERE
      STRFTIME('%Y', date) BETWEEN '2014' AND '2016'
  GROUP BY 
    city, state
)

SELECT 
  tx.city
  , tx.state
  , ty.pop10 AS population
  , tx.incidents
  , ROUND(100000.0 * incidents / ty.pop10, 2 ) 
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

| city           | state | population | incidents | incidents_per_100k |
| -------------- | ----- | ---------- | --------- | ------------------ |
| Waco           | TX    | 124805     | 11        | 8.81               |
| Orlando        | FL    | 238300     | 17        | 7.13               |
| Kansas City    | KS    | 145786     | 10        | 6.86               |
| Flint          | MI    | 102434     | 7         | 6.83               |
| San Bernardino | CA    | 209924     | 14        | 6.67               |
| St. Louis      | MO    | 319294     | 21        | 6.58               |
| Midland        | TX    | 111147     | 7         | 6.3                |
| Topeka         | KS    | 127473     | 8         | 6.28               |
| Stockton       | CA    | 291707     | 18        | 6.17               |
| Knoxville      | TN    | 178874     | 11        | 6.15               |
| Birmingham     | AL    | 212237     | 13        | 6.13               |
| Tulsa          | OK    | 391906     | 24        | 6.12               |
| Beaumont       | TX    | 118296     | 7         | 5.92               |
| Bakersfield    | CA    | 347483     | 20        | 5.76               |
| Baton Rouge    | LA    | 229493     | 13        | 5.66               |
| Pueblo         | CO    | 106595     | 6         | 5.63               |
| Huntsville     | AL    | 180105     | 10        | 5.55               |
| Modesto        | CA    | 201165     | 11        | 5.47               |
| Kansas City    | MO    | 459787     | 25        | 5.44               |
| Cincinnati     | OH    | 296943     | 16        | 5.39               |


## Related reading


GQ Magazine: [Meet the Man Who Spends 10 Hours a Day Tracking Police Shootings](https://www.gq.com/story/fatal-encounters-police-statistics-interview)

> (emphasis added)

> In 2012, I was the editor of a newspaper. I was driving home from work and I came across this scene of chaos. There were more police cars there than I had ever seen. I realized that either a cop had just killed somebody, or somebody killed a cop.

> It was a Friday night and I just came home and I sat down, and I just tried to figure out how often that happens. So I looked at the FBI, and they have a number that they release every year called “justifiable homicides.”

> **It said that there were about 400 killings a year of people by police. But I just wanted to drill down into that data**. And I went straight to Florida, because Florida has a bit of a reputation [of police shootings.] And I figured that those numbers would be high. **And yet, according to the FBI, there had never been a person killed by police in the state of Florida.**

> **I realized, at that moment, that the whole thing was kind of a lie.**



Reddit IAMA: [I’m D. Brian Burghart, a journalist who was offended by the government’s lack of statistics on police-involved deaths, so I started the Fatal Encounters website. AMA!](https://www.reddit.com/r/IAmA/comments/2eyrdz/im_d_brian_burghart_a_journalist_who_was_offended/)
