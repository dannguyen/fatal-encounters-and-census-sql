DBNAME=fatal-encounters-and-census-2010.sqlite


sqlite3 ${DBNAME} < schemas.sql


# echo "Loading places table"

# cat data/census-gazetteer-places-2010.csv \
#   | head -n 10000 \
#   | csvsql --no-create --insert --no-inference \
#            --db sqlite:///${DBNAME} \
#            --tables census_places

# echo "Loading zctas table"

# cat data/census-gazetteer-zcta-2010.csv \
#   | csvsql --no-create --insert --no-inference \
#            --db sqlite:///${DBNAME} \
#            --tables census_zctas


# echo "Loading fatalencounters table"

# cat data/wrangled-fatal-encounters.csv \
#   | csvsql --no-create --insert --no-inference \
#            --db sqlite:///${DBNAME} \
#            --tables fatal_encounters
