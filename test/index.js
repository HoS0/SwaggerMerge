var swaggermerge = require('../index')

var swaggerOne = require('./swagger1.json')
var swaggerTwo = require('./swagger2.json')

var info = {
    version: "0.0.1",
    title: "merged swaggers",
    description: "all mighty services merged together\n"
}
var schemes = ['http']

swaggerOne.paths = JSON.parse(JSON.stringify(swaggerTwo.paths))
swaggerOne.basePath = swaggerTwo.basePath

swaggermerge.on('warn', function (msg) {
    console.warn(msg)
})

merged = swaggermerge.merge([swaggerOne, swaggerTwo], info, '/api', 'test.com', schemes)
