'use strict';

// Instantiate express and app
var express = require('express');
var app = express();
var exports = module.exports = {};

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
mongoClient.connect(MONGO_URL, function (err, returnedDb) {
    if (err) {
        console.error(err);
        throw new Error(err);
    }
    //console.log('Connection established to', MONGO_URL);
    db = returnedDb;
    collection = db.collection('birds');
});

// Use Ajv
var Ajv = require('ajv');
var ajvClient = new Ajv();
var postRequestValidator;
var postResponseValidator;
var getValidator;
var getByIdValidator;

// Schema files
var POST_BIRDS_REQUEST_SCHEMA = './schemas/post-birds-request.json';
var POST_BIRDS_RESPONSE_SCHEMA = './schemas/post-birds-response.json';
var GET_BIRDS_RESPONSE_SCHEMA = './schemas/get-birds-response.json';
var GET_BIRDS_ID_RESPONSE_SCHEMA = './schemas/get-birds-id-response.json';

// Use fs to read schemas
var fs = require('fs');
fs.readFile(POST_BIRDS_REQUEST_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
        throw new Error(err);
    }
    postRequestValidator = ajvClient.compile(JSON.parse(data));
});
fs.readFile(POST_BIRDS_RESPONSE_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
        throw new Error(err);
    }
    postResponseValidator = ajvClient.compile(JSON.parse(data));
});
fs.readFile(GET_BIRDS_RESPONSE_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
        throw new Error(err);
    }
    getValidator = ajvClient.compile(JSON.parse(data));
});
fs.readFile(GET_BIRDS_ID_RESPONSE_SCHEMA, 'utf-8', function (err, data) {
    if (err) {
        console.error(err);
        throw new Error(err);
    }
    getByIdValidator = ajvClient.compile(JSON.parse(data));
});

function errorHandler(err, req, res, next) {
    console.error(err.stack);
    if (res.headerSent) {
        return next(err);
    }
    // Set status to Internal Server Error
    res.status(500);
    db.close();
}
app.use(errorHandler);

// POST request handler
app.post('/birds', jsonBodyParser, function (req, res) {
    var data = req.body,
        keys;
    if (!data) {
        res.sendStatus(400);
    } else {

        // Validate data
        if (!postRequestValidator(data)) {
            console.error(postRequestValidator.errors);
            res.sendStatus(400);
        } else {

            keys = Object.keys(data);
            if (keys.indexOf('visible') === -1) {
                data.visible = false;
            }
            // data['added'] in UTC YYYY-MM-DD format
            if (keys.indexOf('added') === -1) {
                data.added = new Date().toISOString().replace(/\T.+/, '');
            } // TODO: check if date format is valid

            // Add to DB
            if (collection) {
                collection.insert(data, function (err, result) {
                    if (err) {
                        console.error(err);
                        res.sendStatus(400);
                    } else {
                        //console.log('POST: ' + result.insertedIds[0]);
                        var resultData = result.ops[0];
                        resultData.id = resultData._id.toString();
                        delete resultData._id;
                        if (!postResponseValidator(resultData)) {
                            console.error(postResponseValidator.errors);
                            res.sendStatus(400);
                        } else {
                            res.status(201).json(resultData);
                        }
                    }
                });
            } else {
                res.sendStatus(500);
            }
        }
    }
});

// GET request handler, returns all finds
app.get('/birds', function (req, res) {
    //console.log('GET: All');
    // Empty request body

    var newResult = [],
        cursor;
    if (collection) {
        cursor = collection.find();
        cursor.forEach(function (result) {
            if (result) {
                var data = result;
                data.id = data._id.toString();
                delete data._id;
                if (!getByIdValidator(data)) {
                    console.error(getByIdValidator.errors);
                } else {
                    newResult.push(JSON.stringify(data));
                }
            }
        }, function (err) {
            if (err) {
                console.error(err);
            } else {
                if (!getValidator(newResult)) {
                    console.error(getValidator.errors);
                    res.sendStatus(500).json(newResult);
                } else {
                    res.json(newResult);
                }
            }
        });
    } else {
        res.sendStatus(500);
    }
});

// GET request handler, returns entry by id
app.get('/birds/:id', function (req, res) {
    //console.log('GET: ' + req.params.id);
    var id = req.params.id;

    if (collection) {
        collection.find({'_id': new ObjectID(id)}).limit(1).next(function (err, result) {
            if (err) {
                console.error(err);
                res.sendStatus(404);
            } else if (result) {
                var data = result;
                data.id = data._id.toString();
                delete data._id;
                if (!getByIdValidator(data)) {
                    console.error(getByIdValidator.errors);
                    res.sendStatus(404);
                } else {
                    res.json(data);
                }
            } else {
                res.sendStatus(404);
            }
        });
    } else {
        res.sendStatus(500);
    }
});

// DELETE request handler, deletes entry by id
app.delete('/birds/:id', function (req, res) {
    //console.log('DELETE: ' + req.params.id);

    var id = req.params.id;
    if (collection) {
        collection.deleteOne({'_id': new ObjectID(id)}, function (err, result) {
            if (err) {
                console.error(err);
                res.sendStatus(404);
            } else {
                if (result.result.ok === 1 && result.result.n === 1) {
                    res.sendStatus(200);
                } else {
                    res.sendStatus(404);
                }
            }
        });
    } else {
        res.sendStatus(500);
    }

});

app.listen(3000, function () {
    //console.log('Listening on port 3000...');
});

exports.appClose = function () {
    app.close();
};

/*
function isValidDate (value, format) {
    var delimiter = /[^YMD]/.exec(format)[0];
    var theFormat = format.split(delimiter);
    var theDate = value.split(delimiter);

    isDate = function (date, format) {
        var Y, M, D;
        for (var i=0, len=format.length; i<len; i++) {
            if (/Y/.test(format[i])) Y = date[i];
            if (/M/.test(format[i])) M = date[i];
            if (/D/.test(format[i])) D = date[i];
        }
        return (
                Y && Y.length === 4 &&
                M > 0 && M < 13 &&
                D > 0 && D <= (new Date(Y, M, 0)).getDate()
               )
    }
    return isDate(theDate, theFormat);
}
*/
