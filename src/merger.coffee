EventEmitter    = require('events')

module.exports = () ->
    class merger extends EventEmitter
        _mergeSecurityDefinitions: (swaggers) =>
            ret = undefined
            for swagger in swaggers
                if swagger.securityDefinitions
                    for key in Object.keys(swagger.securityDefinitions)
                        ret ?= {}
                        if !ret[key]
                            ret[key] = swagger.securityDefinitions[key]
                        else
                            @emit("warn", "multiple security definitions with the same name has define in swagger collection: #{key}")

            return ret

        _mergedSchemes: (swaggers) =>
            ret = []
            for swagger in swaggers
                if swagger.schemes
                    for scheme in swagger.schemes
                        if scheme and ret.indexOf(scheme) < 0
                            ret.push(scheme)

            return ret

        _mergedConsume: (swaggers) =>
            ret = []
            for swagger in swaggers
                if swagger.consumes
                    for consume in swagger.consumes
                        if consume and ret.indexOf(consume) < 0
                            ret.push(consume)

            return ret


        _mergedProduces: (swaggers) =>
            ret = []
            for swagger in swaggers
                if swagger.produces
                    for produce in swagger.produces
                        if produce and ret.indexOf(produce) < 0
                            ret.push(produce)

            return ret

        _mergedPaths: (swaggers) =>
            ret = undefined
            for swagger in swaggers
                if swagger.paths
                    swagger.basePath ?= ''
                    for key in Object.keys(swagger.paths)
                        ret ?= {}
                        if !ret[swagger.basePath+key]
                            ret[swagger.basePath+key] = swagger.paths[key]
                        else
                            @emit("warn", "multiple routes with the same name and base path has define in swagger collection: #{swagger.basePath+key}")
            return ret

        _mergedDefinitions: (swaggers) =>
            ret = undefined
            for swagger in swaggers
                if swagger.definitions
                    for key in Object.keys(swagger.definitions)
                        ret ?= {}
                        if !ret[key]
                            ret[key] = swagger.definitions[key]
                        else
                            @emit("warn", "multiple definitions with the same name has define in swagger collection: #{key}")
            return ret

        merge: (swaggers, info, basePath, host, schemes)->
            if typeof info isnt 'object'
                throw 'no info object as input or different format'

            if typeof basePath isnt 'string'
                throw 'no basePath string as input or different format'

            if typeof host isnt 'string'
                throw 'no host string as input or different format'

            ret =
                swagger: "2.0"
                info: info
                host: host
                basePath: basePath
                schemes: schemes || @_mergedSchemes(swaggers)
                consumes: @_mergedConsume(swaggers)
                produces: @_mergedProduces(swaggers)

            securityDefinitions = @_mergeSecurityDefinitions(swaggers)
            ret.securityDefinitions = securityDefinitions if securityDefinitions

            definitions = @_mergedDefinitions(swaggers)
            ret.definitions = definitions if definitions

            paths = @_mergedPaths(swaggers)
            ret.paths = paths if paths

            return ret
