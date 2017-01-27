

# swagger-merge

[![Build Status](https://travis-ci.org/HoS0/SwaggerMerge.svg?branch=master)](https://travis-ci.org/HoS0/SwaggerMerge) [![Coverage Status](https://coveralls.io/repos/github/HoS0/SwaggerMerge/badge.svg?branch=master)](https://coveralls.io/github/HoS0/SwaggerMerge?branch=master)

merging multiple swagger 2.0 JSONs into one JSON

`npm install swagger-merge`

## Example

``` javascript
var swaggermerge = require('swagger-merge')
var swaggerOne = require('./swagger1.json')
var swaggerTwo = require('./swagger2.json')
var info = {
    version: "0.0.1",
    title: "merged swaggers",
    description: "all mighty services merged together\n"
}
var schemes = ['http']

swaggermerge.on('warn', function (msg) {
    console.log(msg)
})

merged = swaggermerge.merge([swaggerOne, swaggerTwo], info, '/api', 'test.com', schemes)
```

## Running Tests

Run test by:

`gulp test`

This software is licensed under the MIT License.
