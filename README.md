# Introduction
Basic POST, GET and DELETE request handler as per the Saltside requirements specified 
[here!](https://gist.github.com/sebdah/265f4255cb302c80abd4)

# Installation

# Starting the app
`$> node index.js`

# Running the test suite
`$> cd tests`
`$> ./run_tests.sh`

# Stack
* MongoDB for database listening on port 27017
* Express for webapp framework listening on port 3000
* Node.js

# MongoDB Notes
* Data is stored in /var/lib/mongodb
* Logs are stored in /var/log/mongodb
* MongoDB config file /etc/mongod.conf
* MongoDB server is run as 'mongdb' user
