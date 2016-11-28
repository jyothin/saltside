var request = require('request'),
    assert = require('assert'),
    app = require('../index.js');
var URL = 'http://localhost:3000/birds';

var id;

// POST
describe('POST request test', function () {
    describe('Post /birds', function () {

        it('returns status code 201', function () {
            request.post({url: URL,
                    json: {name: 'Parrot', family: 'Parrot',
                        continents: ['Asia', 'South America']}},
                function (err, res, body) {
                    assert.equal(201, res.statusCode);
                    id = body.id;
                    done();
                }
            );
        });

        it('returns status code 400', function () {
            request.post({url: URL, 
                    json: {name: 'Parrot', family: 'Parrot', 
                        continent: ['Asia', 'South America']}},
                function (err, res, body) {
                    assert.equal(400, res.statusCode);
                    done();
                }
            );
        });

        it('returns status code 400', function () {
            request.post({url: URL, 
                    json: {family: 'Parrot', 
                        continents: ['Asia', 'South America']}},
                function (err, res, body) {
                    assert.equal(400, res.statusCode);
                    done();
                }
            );
        });

        it('returns status code 400', function () {
            request.post({url: URL, 
                    json: {name: 'Parrot', 
                        continents: ['Asia', 'South America']}},
                function (err, res, body) {
                    assert.equal(400, res.statusCode);
                    done();
                }
            );
        });

        it('returns status code 400', function () {
            request.post({url: URL, 
                    json: {name: 'Parrot', 'family': 'Parrot'
                        }},
                function (err, res, body) {
                    assert.equal(400, res.statusCode);
                    done();
                }
            );
        });

    });
});

// GET
describe('GET request test', function () {

    // GET All
    describe('Get /birds', function () {
        it('returns status code 200 and birds list in body', function () {
            request.get(URL, function (err, res, body) {
                assert.equal(200, res.statusCode);
                assert.equal('[object Array]', Object.prototype.toString.call(body));

                id = JSON.parse(body[0]).id;

                done();
            });            
        });
    });

    // GET By ID
    describe('Get /birds/{id}', function () {
        it('returns bird details in the body', function () {
            request.get(URL+'/'+id, {headers: {'Accept': 'application/json'}}, function (err, res, body) {
                assert.equal(200, res.statusCode);
                assert.equal('[object Array]', Object.prototype.toString.call(body));
                app.appClose();
                done();
            });
        });
    });

});

// DELETE
