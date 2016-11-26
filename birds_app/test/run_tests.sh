#!/bin/bash
SERVER=http://localhost
PORT=3000
URL_PATH=birds

RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

function generateVisibleBirdData {
    NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9  ' | fold -w 32 | head -n 1)
    FAMILY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    NUM_CONTINENTS=$(cat /dev/urandom | tr -dc '1-7' | fold -w 256 | head -n 1 | \
        head --bytes 1)
    LIST_CONTINENTS=("Africa" "Antartica" "Asia" "Australia/Oceania" "Europe" "North America" \
                     "South America")
    CONTINENTS='['
    CONTINENTS+='"'
    CONTINENTS+=${LIST_CONTINENTS[0]}
    CONTINENTS+='"'
    for ((i=1; i<$NUM_CONTINENTS; i++))
    do
        CONTINENTS+=","
        CONTINENTS+='"'
        CONTINENTS+=${LIST_CONTINENTS[$i]}
        CONTINENTS+='"'
    done
    CONTINENTS+=']'
    printf '{"name": "%s", "family": "%s", "continents": %s, "visible": %s}\n' \
        "$NAME" "$FAMILY" "$CONTINENTS" "true" > test_input.json
}

function generateBirdData {
    NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9  ' | fold -w 32 | head -n 1)
    FAMILY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    NUM_CONTINENTS=$(cat /dev/urandom | tr -dc '1-7' | fold -w 256 | head -n 1 | \
        head --bytes 1)
    LIST_CONTINENTS=("Africa" "Antartica" "Asia" "Australia/Oceania" "Europe" "North America" \
                     "South America")
    CONTINENTS='['
    CONTINENTS+='"'
    CONTINENTS+=${LIST_CONTINENTS[0]}
    CONTINENTS+='"'
    for ((i=1; i<$NUM_CONTINENTS; i++))
    do
        CONTINENTS+=","
        CONTINENTS+='"'
        CONTINENTS+=${LIST_CONTINENTS[$i]}
        CONTINENTS+='"'
    done
    CONTINENTS+=']'
    printf '{"name": "%s", "family": "%s", "continents": %s}\n' \
        "$NAME" "$FAMILY" "$CONTINENTS" > test_input.json
}

# Post 1
generateVisibleBirdData
echo "Running Test 1: curl -I $SERVER:$PORT/$URL_PATH -d test_input.json"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
         -H "Content-Type:application/json" \
         $SERVER:$PORT/$URL_PATH)
if [ $STATUS_CODE != 201 ]
then
    echo -e "${RED}Fail${NO_COLOR}: $STATUS_CODE"
else
    echo -e "${GREEN}Pass${NO_COLOR}"
fi

# Get 1 by Id
#ID=58399990731ddd35c06cef9a
ID=5839a24b55ab2f381dc19557
echo "Running Test 2: curl -I $SERVER:$PORT/$URL_PATH/$ID"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
                $SERVER:$PORT/$URL_PATH/$ID)
if [ $STATUS_CODE != 200 ]
then
    echo -e "${RED}Fail${NO_COLOR}: $STATUS_CODE"
else
    echo -e "${GREEN}Pass${NO_COLOR}"
fi

# Get All
# Delete 1

# Post All
# Get All by Id
# Get All
# Delete All

# Post 1
# Get 1 by Id
# Delete 1

# Post 1 multiple
# Get 1 by Id multiple
# Delete 1 multiple

# Delete 1 repeated

