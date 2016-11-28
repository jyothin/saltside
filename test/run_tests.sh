#!/bin/bash
SERVER=http://localhost
PORT=3000
URL_PATH=birds

RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

function validateStatusCode {
    if [ $1 != $2 ]
    then
        echo -e "${RED}Fail${NO_COLOR}: $1"
    else
        echo -e "${GREEN}Pass${NO_COLOR}"
    fi
}

function generateFullBirdData {
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

    printf '{"name": "%s", "family": "%s", "continents": %s, "visible": %s, "added": "%s"}\n' \
        "$NAME" "$FAMILY" "$CONTINENTS" "true" "2016-11-26" > test_input.json
}

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

function generateBirdDataNameRemoved {
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
    printf '{"family": "%s", "continents": %s}\n' \
        "$FAMILY" "$CONTINENTS" > test_input.json
}

function generateBirdDataFamilyRemoved {
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
    printf '{"name": "%s", "continents": %s}\n' \
        "$NAME" "$CONTINENTS" > test_input.json
}

function generateBirdDataContinentRemoved {
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
    printf '{"name": "%s", "family": "%s"}\n' \
        "$NAME" "$FAMILY" > test_input.json
}

# Start tests

# Post 1
generateFullBirdData
echo "Running Test 1 (POST 1): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
         -H "Content-Type:application/json" \
         $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 201

# Get All
echo "Running Test 3 (GET All): curl -s -o /dev/null -X GET $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o ./test_output.json -w "%{http_code}" -H "Accept:application/json" -X GET \
                $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 200
RESULT=$(jq '.[0]|fromjson|.id' test_output.json)

# Get 1 by Id
ID=${RESULT:1: -1}
echo "Running Test 2 (GET 1 by Id): curl -s -o /dev/null -X GET $SERVER:$PORT/$URL_PATH/$ID"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
                $SERVER:$PORT/$URL_PATH/$ID)
validateStatusCode $STATUS_CODE 200

# Delete 1
ID=${RESULT:1: -1}
echo "Running Test 4 (DELETE): curl -s -o /dev/null -X DELETE $SERVER:$PORT/$URL_PATH/$ID"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
                $SERVER:$PORT/$URL_PATH/$ID)
validateStatusCode $STATUS_CODE 200

# Delete 1 repeated
ID=${RESULT:1: -1}
echo "Running Test 5 (DELETE removed): curl -s -o /dev/null -X DELETE $SERVER:$PORT/$URL_PATH/$ID"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
                $SERVER:$PORT/$URL_PATH/$ID)
validateStatusCode $STATUS_CODE 404

# Post invalid data
generateBirdDataNameRemoved
echo "Running Test 6 (POST invalid name): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
         -H "Content-Type:application/json" \
         $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 400

generateBirdDataFamilyRemoved
echo "Running Test 7 (POST invalid family): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
         -H "Content-Type:application/json" \
         $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 400

generateBirdDataContinentRemoved
echo "Running Test 8 (POST invalid continent): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
         -H "Content-Type:application/json" \
         $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 400

# Post Many
echo "Running Test 9 (POST Many): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
for i in {0..10}
do
    generateFullBirdData
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
             -H "Content-Type:application/json" \
             $SERVER:$PORT/$URL_PATH)
    if [ $STATUS_CODE != 201 ]
    then
        echo -e "${RED}$i POST Failed${NO_COLOR}: $STATUS_CODE"
    fi
done
echo -e "${GREEN}Completed${NO_COLOR}"

# Get All
echo "Running Test 10 (GET All): curl -s -o /dev/null -X GET $SERVER:$PORT/$URL_PATH"
STATUS_CODE=$(curl -s -o ./test_output.json -w "%{http_code}" -H "Accept:application/json" -X GET \
                $SERVER:$PORT/$URL_PATH)
validateStatusCode $STATUS_CODE 200

# Get All by Id
echo "Running Test 11 (GET each by Id): curl -s -o /dev/null -X GET $SERVER:$PORT/$URL_PATH/ID"
RESULT=$(jq '.[]|fromjson|.["id"]' test_output.json)
for i in $RESULT
do
    ID=${i:1: -1}
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET \
                    $SERVER:$PORT/$URL_PATH/$ID)
    if [ $STATUS_CODE != 200 ]
    then
        echo -e "${RED}$i GET $ID Failed${NO_COLOR}: $STATUS_CODE"
    fi
done
echo -e "${GREEN}Completed${NO_COLOR}"

# Delete All by Id
echo "Running Test 12 (DELETE each by Id): curl -s -o /dev/null -X DELETE $SERVER:$PORT/$URL_PATH/ID"
RESULT=$(jq '.[]|fromjson|.["id"]' test_output.json)
for i in $RESULT
do
    ID=${i:1: -1}
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
                    $SERVER:$PORT/$URL_PATH/$ID)
    if [ $STATUS_CODE != 200 ]
    then
        echo -e "${RED}$i GET $ID Failed${NO_COLOR}: $STATUS_CODE"
    fi
done
echo -e "${GREEN}Completed${NO_COLOR}"

function post {
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "@test_input.json" \
             -H "Content-Type:application/json" \
             $SERVER:$PORT/$URL_PATH)
    if [ $STATUS_CODE != 201 ]
    then
        echo -e "${RED}POST Failed${NO_COLOR}: $STATUS_CODE"
    fi
}

# Post 100 concurrent
echo "Running Test 13 (POST concurrent): curl -s -o /dev/null -X POST -d @test_input.json $SERVER:$PORT/$URL_PATH"
set -m
for i in `seq 100`
do
    post &
done
while [ 1 ]
do
    fg 2> /dev/null
    if [ $? == 1 ]
    then
        break
    fi
done
