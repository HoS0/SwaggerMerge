# swagger-merge

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

merged = swaggermerge.merge([swaggerOne, swaggerTwo], info, '/api', 'test.com')
```

## Running Tests

Run test by:

`gulp test`

This software is licensed under the MIT License.
