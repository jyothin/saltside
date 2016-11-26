// Instantiate express and app
var express = require('express');
var app = express();

// Use body-parser middleware to parse json body
var bodyParser = require('body-parser');
//app.use(bodyParser.json());
var jsonBodyParser = bodyParser.json();

// Instantiate MongoDB client
var MONGO_URL = 'mongodb://localhost:27017';
var mongodb = require('mongodb');
var mongoClient = mongodb.MongoClient;
var ObjectID = mongodb.ObjectID;
var db;
var collection;
mongoClient.connect(MONGO_URL, function(err, returnedDb) {
    if (err) {
        console.log('Unable to connect to the mongoDB server. Error: ', err);
    } else {
        console.log('Connection established to', MONGO_URL);
        db = returnedDb;
        collection = db.collection('birds');
    }
});

// Use Ajv
var ajv = require('ajv');
var ajvClient = new ajv();
var postValidator;
var getValidator;
var getByIdValidator;

// Schema files
var POST_BIRDS_REQUEST_SCHEMA = './schemas/post-birds-request.json';
var GET_BIRDS_RESPONSE_SCHEMA = './schemas/get-birds-response.json';
var GET_BIRDS_ID_RESPONSE_SCHEMA = './schemas/get-birds-id-response.json';

// Use fs to read schemas
var fs = require('fs');
fs.readFile(POST_BIRDS_REQUEST_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
    } else {
        postValidator = ajvClient.compile(JSON.parse(data));
    }
});
fs.readFile(GET_BIRDS_ID_RESPONSE_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
    } else {
        getByIdValidator = ajvClient.compile(JSON.parse(data));
    }
});

// TODO: check this
function errorHandler (err, req, res, next) {
    console.error(err.stack)
    if (res.headerSent) {
        return next(err)
    }
    // Set status to Internal Server Error
    res.status(500)
    db.close();
}
app.use(errorHandler);

// POST request handler
app.post('/birds', jsonBodyParser, function (req, res) {
    console.log('POST:');
    var data = req.body;
    if (!data) {
        res.sendStatus(400);
    } else {

        // Validate data
        if (!postValidator(data)) {
            console.log(postValidator.errors);
            res.sendStatus(400);
        } else {

            var keys = Object.keys(data);
            if (keys.indexOf('visible') == -1) {
                data['visible'] = false;
            } // TODO: check that it is boolean
            // data['added'] in UTC YYYY-MM-DD format
            if (keys.indexOf('added') == -1) {
              data['added'] = new Date().toISOString().replace(/\T.+/,''); 
            } // TODO: check that it is YYYY-MM-DD format

            // Add to DB
            collection.insert(data, function (err, result) {
                if (err) {
                    console.log(err);
                    res.sendStatus(400);
                } else {
                    console.log(result['insertedIds'][0]);
                    res.sendStatus(201);
                }
            });
        }
    }
});

// GET request handler, returns all finds
app.get('/birds', function (req, res) {
    console.log('GET:');
    res.send('Hello World!')
    // Empty request body
    // if found && data['visible']:
    //   res.sendStatus(200);
    //   res.sendjson(data)
});

// GET request handler, returns entry by id
app.get('/birds/:id', function (req, res) {
    console.log('GET: '+req.params.id);
    var id = req.params.id;
    // Empty request body
    collection.find({'_id': ObjectID(id)}).toArray(function (err, result) {
        if (err) {
            console.log(err);
            res.sendStatus(404);
        } else if (result[0]) {
            var data = result[0];
            if (data['visible']) {
                data['id'] = data['_id'].toString();
                delete data['_id'];
                if (!getByIdValidator(data)) {
                    console.log(getByIdValidator.errors);
                    res.sendStatus(404);
                } else {
                    res.send(data);
                }
            } else  {
                res.sendStatus(404);
            }
        } else {
            res.sendStatus(404);
        }
    });
});

// DELETE request handler, deletes entry by id
app.delete('/birds/:id', function (req, res) {
    console.log('DELETE: '+req.params.id);
    // Empty request body
    var birdId = req.params.id;
    collection.remove({id: birdId}, function (err, result) {
        if (err) {
            console.error(err);
            res.sendStatus(404);
        } else {
            res.sendStatus(200);
        }
    });
    // Empty response body
});

// TODO: Do I need this?
if (db) {
    db.close();
}

app.listen(3000, function () {
    console.log('Listening on port 3000...')
});
