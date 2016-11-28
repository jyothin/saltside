# Introduction
Basic HTTP service with JSON API that handles POST, GET and DELETE requests as per the Saltside requirements specified 
[here](https://gist.github.com/sebdah/265f4255cb302c80abd4)

Supported requests:
* GET /birds - List all birds
* POST /birds - Add a new bird
* GET /birds/{id} - Get details on a specific bird
* DELETE /birds/{id} - Delete a bird by id

# Installation
* `npm install`

# Test Suite
## Unit Tests
### Dependencies (installed on `npm install`)
* [mocha](https://mochajs.org/)
* [request](https://www.npmjs.com/package/request)

### Running the Unit Tests
`npm test`

## Integration Tests
### Dependencies
* [jq](https://stedolan.github.io/jq/)
    * jq is a lightweight and flexible command-line JSON processor
    * Used for running the integration tests
    * See [here](https://stedolan.github.io/jq/download/) for installing jq for your distribution

### Running the test suite
#### Starting the app
`$> node index.js`

#### Run the tests
* `$> cd tests`
* `$> ./run_tests.sh`

## Test Result
Tests run successfully on a Debian Linux standalone PC. Not tested on other OSes.

# Code Quality Checks
`$> jslint --nomen index.js`

# Coverage
## Dependency
`npm install istanbul`

## Running coverage
`istanbul cover node_modules/.bin/_mocha -- test/test.js -R spec`

# Stack
* MongoDB for database listening on port 27017
* Express for webapp framework listening on port 3000
* Node.js

# MongoDB Notes
* Data is stored in /var/lib/mongodb
* Logs are stored in /var/log/mongodb
* MongoDB config file /etc/mongod.conf
* MongoDB server is run as 'mongdb' user

