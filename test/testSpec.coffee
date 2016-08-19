swaggermerge = require('../index')
swaggerOne = require('./swagger1')
swaggerTwo = require('./swagger2')
swaggerThree = require('./swagger3')
swagger = require('swagger2-utils');

describe "Run swagger merge", ()->
    it "and load any verify two swagger json", (done)->
        expect(swagger.validate(swaggerOne)).toBe(true)
        expect(swagger.validate(swaggerTwo)).toBe(true)
        expect(swagger.validate(swaggerThree)).toBe(true)
        done()

    it "and merge two simple swaggers", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)
        done()

    it "and merge two simple swaggers and rewrite schemes", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com', ['http'])
        expect(swagger.validate(merged)).toBe(true)
        expect(merged.schemes.length).toBe(1)
        expect(merged.schemes[0]).toBe('http')
        done()

    it "merge swagger with no basePath", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        delete swaggerOne.basePath
        delete swaggerTwo.basePath
        delete swaggerThree.basePath

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)
        expect(Object.keys(merged.paths)[0].startsWith('undefined')).toBe(false)
        done()
