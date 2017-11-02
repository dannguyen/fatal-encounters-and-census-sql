# The data/fatal-encounters.csv file is a bit convoluted, with long column names
# and columns that don't interest us. The script below creates a new file,
# data/wrangled-fatal-encounters.csv, by concatenating the clean-fe-headers.csv
# file with a trimmed version of data/fatal-encounters.csv

cat clean-fe-headers.csv \
    | tr '\n' ',' \
    | gsed 's/,$/\n/' \
    > data/wrangled-fatal-encounters.csv


cat data/fatal-encounters.csv \
    | csvcut -c \
'Date of injury resulting in death (month/day/year)',\
"Subject's name",\
"Subject's age",\
"Subject's gender",\
"Subject's race",\
'Symptoms of mental illness?',\
'Location of death (city)',\
'Location of death (state)',\
'Location of death (zip code)',\
'Location of death (county)',\
'Location of injury (address)',\
'Official disposition of death (justified or other)',\
'Cause of death',\
'A brief description of the circumstances surrounding the death',\
'Link to news article or photo of official document',\
'URL of image of deceased',\
'Unique identifier' \
    | tail -n +2 \
    | sed '$ d'  \
    | gsed 's#^\([0-9]\{2\}\)/\([0-9]\{2\}\)/\([0-9]\{4\}\)#\3-\1-\2#' \
    >> data/wrangled-fatal-encounters.csv



### The gazetteer files are tab-delimited, this script converts them to CSV:


unzip -p data/census-gazetteer-zcta-2010.zip  \
    | csvformat -t \
    | gsed 's/,\s\+/,/g' \
    | gsed 's/\s\+$//g' \
    > data/census-gazetteer-zcta-2010.csv

unzip -p data/census-gazetteer-places-2010.zip \
    > data/census-gazetteer-places-2010.txt

csvformat -t -e 'windows-1252' \
    data/census-gazetteer-places-2010.txt \
    | gsed 's/\s\+$//g' \
    | gsed 's/,\s\+/,/g' \
    > data/census-gazetteer-places-2010.csv








