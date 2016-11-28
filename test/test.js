var request = require('request'),
    assert = require('assert'),
    app = require('../index.js');
var URL = 'http://localhost:3000/birds';

// POST

// GET
describe('GET request test', function () {
    describe('Get /birds', function () {
        it('returns status code 200', function () {
            request.get(URL, function (err, res, body) {
                assert.equal(200, res.statusCode);
                done();
            });            
        });
        it('returns birds list in the body', function () {
            request.get(URL, function (err, res, body) {
                //assert.equal(200, res.statusCode);
                console.log(body);
                app.appClose();
                done();
            });            
        });
    });
});

// GET By ID


// DELETE
