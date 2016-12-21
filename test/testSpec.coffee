swagger = require('swagger2-utils');

describe "Run swagger merge", ()->
    swaggerOne = {}
    swaggerTwo = {}
    swaggerThree = {}
    swaggermerge = {}

    beforeEach (done)->
      swaggerOne = JSON.parse(JSON.stringify(require('./swagger1')))
      swaggerTwo = JSON.parse(JSON.stringify(require('./swagger2')))
      swaggerThree = JSON.parse(JSON.stringify(require('./swagger3')))

      swaggermerge = require('../index')
      done()

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

    it "merge swagger with no basePath", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        delete swaggerOne.securityDefinitions
        delete swaggerTwo.securityDefinitions
        delete swaggerThree.securityDefinitions

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)
        done()

    it "merge swagger with collision paths", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        swaggerOne.paths = JSON.parse JSON.stringify swaggerTwo.paths
        swaggerOne.basePath = swaggerTwo.basePath

        swaggermerge.on 'warn', (msg)=>
          done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)

    it "merge swagger with collision definitions", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        swaggerOne.definitions = JSON.parse JSON.stringify swaggerTwo.definitions

        swaggermerge.on 'warn', (msg)=>
          done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)

    it "merge swagger with collision security definitions", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        swaggerOne.securityDefinitions = JSON.parse JSON.stringify swaggerThree.securityDefinitions

        swaggermerge.on 'warn', (msg)=>
          done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)

    it "merge swagger with collision parameters", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        swaggerOne.parameters = JSON.parse JSON.stringify swaggerTwo.parameters

        swaggermerge.on 'warn', (msg)=>
            done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)

    it "merge swagger with collision responses", (done)->
        info =
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"

        swaggerOne.responses = JSON.parse JSON.stringify swaggerTwo.responses

        swaggermerge.on 'warn', (msg)=>
            done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)
    it "merge swagger with tags", (done)->
        info = 
            version: "0.0.1",
            title: "merged swaggers",
            description: "all mighty services merged together\n"
        swaggerOne.responses = JSON.parse JSON.stringify swaggerTwo.responses

        swaggermerge.on 'warn', (msg)=>
            done()

        merged = swaggermerge.merge([swaggerOne, swaggerTwo, swaggerThree], info, '/api', 'test.com')
        expect(swagger.validate(merged)).toBe(true)
        expect(merged.tags).not.toBeNull()
