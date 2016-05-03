# HoSCom

merging multiple swagger 2.0 JSONs into one JSON

`npm install swagger-merge`

## Example

``` javascript
var swaggermerge = require('swagger-merge')
var swaggerOne = require('./swagger1.json')
var swaggerTwo = require('./swagger2.json')

var merged = swaggermerge.merge([swaggerOne, swaggerTwo]);
```

## Running Tests

Run test by:

`gulp test`

This software is licensed under the MIT License.
