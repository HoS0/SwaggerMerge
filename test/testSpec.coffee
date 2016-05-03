swaggermerge = require('../index')
swaggerOne = require('./swagger1')
swaggerTwo = require('./swagger2')
swagger = require('swagger2-utils');

describe "Ruun swagger merge", ()->
    it "and load any verify two swagger json", (done)->
        expect(swagger.validate(swaggerOne)).toBe(true)
        expect(swagger.validate(swaggerTwo)).toBe(true)
        done()

    it "and merge two simple swaggers", (done)->
        merged = swaggermerge.merge([swaggerOne, swaggerTwo])
        expect(swagger.validate(merged)).toBe(true)
        done()
