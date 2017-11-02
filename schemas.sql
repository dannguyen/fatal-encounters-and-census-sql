DROP TABLE IF EXISTS census_places;
DROP TABLE IF EXISTS census_zctas;
DROP TABLE IF EXISTS fatal_encounters;

CREATE TABLE census_places (
    "USPS" TEXT,
    "GEOID" TEXT,
    "ANSICODE" TEXT,
    "NAME" TEXT,
    "LSAD" TEXT,
    "FUNCSTAT" TEXT,
    "POP10" INTEGER,
    "HU10" INTEGER,
    "ALAND" INTEGER,
    "AWATER" INTEGER,
    "ALAND_SQMI" DECIMAL,
    "AWATER_SQMI" DECIMAL,
    "INTPTLAT" DECIMAL,
    "INTPTLONG" DECIMAL
);

CREATE INDEX geoid_on_census_places ON census_places(geoid);
CREATE INDEX usps_on_census_places ON census_places(usps);
CREATE INDEX usps_name_on_census_places ON census_places(usps, name);
CREATE INDEX name_on_census_places ON census_places(name);
CREATE INDEX lnglat_on_census_places ON census_places(INTPTLONG, INTPTLAT);


CREATE TABLE census_zctas (
    "GEOID" TEXT,
    "POP10" INTEGER,
    "HU10" INTEGER,
    "ALAND" INTEGER,
    "AWATER" INTEGER,
    "ALAND_SQMI" DECIMAL,
    "AWATER_SQMI" DECIMAL,
    "INTPTLAT" DECIMAL,
    "INTPTLONG" DECIMAL
);




CREATE INDEX geoid_on_census_zctas ON census_zctas(geoid);
CREATE INDEX lnglat_on_census_zctas ON census_zctas(INTPTLONG, INTPTLAT);


CREATE TABLE fatal_encounters (
    date TEXT,
    name TEXT,
    age TEXT,
    gender TEXT,
    race TEXT,
    mental_illness_symptoms TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    county TEXT,
    address_injury TEXT,
    official_disposition TEXT,
    cause_of_death TEXT,
    circumstances TEXT,
    info_url TEXT,
    image_url TEXT,
    unique_id TEXT
);

CREATE INDEX date_on_fatal_encounters ON fatal_encounters(date);
CREATE INDEX zip_code_on_fatal_encounters ON fatal_encounters(zip_code);
CREATE INDEX city_on_fatal_encounters ON fatal_encounters(city);
CREATE INDEX state_on_fatal_encounters ON fatal_encounters(state);
CREATE INDEX county_on_fatal_encounters ON fatal_encounters(county);
CREATE INDEX statecounty_on_fatal_encounters ON fatal_encounters(state, county);
CREATE INDEX citystate_on_fatal_encounters ON fatal_encounters(state, city);

CREATE INDEX name_on_fatal_encounters ON fatal_encounters(name);
CREATE INDEX age_on_fatal_encounters ON fatal_encounters(age);


.mode csv
.import data/census-gazetteer-places-2010.csv census_places
.import data/census-gazetteer-zcta-2010.csv census_zctas
.import data/wrangled-fatal-encounters.csv fatal_encounters


DELETE FROM census_places WHERE "INTPTLONG"='INTPTLONG';
DELETE FROM census_zctas WHERE "INTPTLONG"='INTPTLONG';
DELETE FROM fatal_encounters WHERE "date"='date';
