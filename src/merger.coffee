mergeSecurityDefinitions = (swaggers) ->
    ret = {}
    for swagger in swaggers
        if swagger.securityDefinitions
            for key in Object.keys(swagger.securityDefinitions)
                ret[key] = swagger.securityDefinitions[key]

    return ret

mergedSchemes = (swaggers) ->
    ret = []
    for swagger in swaggers
        if swagger.schemes
            for scheme in swagger.schemes
                if scheme and ret.indexOf(scheme) < 0
                    ret.push(scheme)

    return ret

mergedConsume = (swaggers) ->
    ret = []
    for swagger in swaggers
        if swagger.consumes
            for consume in swagger.consumes
                if consume and ret.indexOf(consume) < 0
                    ret.push(consume)

    return ret


mergedProduces = (swaggers) ->
    ret = []
    for swagger in swaggers
        if swagger.produces
            for produce in swagger.produces
                if produce and ret.indexOf(produce) < 0
                    ret.push(produce)

    return ret

mergedPaths = (swaggers) ->
    ret = {}
    for swagger in swaggers
        if swagger.paths
            for key in Object.keys(swagger.paths)
                if !ret[swagger.basePath+key]
                    ret[swagger.basePath+key] = swagger.paths[key]
    return ret

mergedDefinitions = (swaggers) ->
    ret = {}
    for swagger in swaggers
        if swagger.definitions
            for key in Object.keys(swagger.definitions)
                if !ret[key]
                    ret[key] = swagger.definitions[key]
    return ret

module.exports = () ->
    merge: (swaggers, info, basePath, host)->
        ret =
            swagger: "2.0"
            info: info
            host: host
            basePath: basePath
            securityDefinitions: mergeSecurityDefinitions(swaggers)
            schemes: mergedSchemes(swaggers)
            consumes: mergedConsume(swaggers)
            produces: mergedProduces(swaggers)
            paths: mergedPaths(swaggers)
            definitions: mergedDefinitions(swaggers)
