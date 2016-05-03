mergedInfo = (swaggers) ->
    swaggers[0].info

mergedHost = (swaggers) ->
    swaggers[0].host

mergedBasePath = (swaggers) ->
    return "/api"

mergedSchemes = (swaggers) ->
    ret = []
    for swagger in swaggers
        for scheme in swagger.schemes
            if scheme and ret.indexOf(scheme) < 0
                ret.push(scheme)

    return ret

mergedConsume = (swaggers) ->
    ret = []
    for swagger in swaggers
        for consume in swagger.consumes
            if consume and ret.indexOf(consume) < 0
                ret.push(consume)

    return ret


mergedProduces = (swaggers) ->
    ret = []
    for swagger in swaggers
        for produce in swagger.produces
            if produce and ret.indexOf(produce) < 0
                ret.push(produce)

    return ret

mergedPaths = (swaggers) ->
    ret = {}
    for swagger in swaggers
        for key in Object.keys(swagger.paths)
            if !ret[swagger.basePath+key]
                ret[swagger.basePath+key] = swagger.paths[key]
    return ret

mergedDefinitions = (swaggers) ->
    ret = {}
    for swagger in swaggers
        for key in Object.keys(swagger.definitions)
            if !ret[key]
                ret[key] = swagger.definitions[key]
    return ret

module.exports = () ->
    merge: (swaggers)->
        ret =
            swagger: "2.0"
            info: mergedInfo(swaggers)
            host: mergedHost(swaggers)
            basePath: mergedBasePath(swaggers)
            schemes: mergedSchemes(swaggers)
            consumes: mergedConsume(swaggers)
            produces: mergedProduces(swaggers)
            paths: mergedPaths(swaggers)
            definitions: mergedDefinitions(swaggers)
