'use strict'
const EventEmitter = require('events')

class Merger extends EventEmitter {
  _mergeSecurityDefinitions(swaggers) {
    let ret = null;
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.securityDefinitions) {
        let ref = Object.keys(swagger.securityDefinitions);
        for (let j = 0; j < ref.length; j++) {
          let key = ref[j];
          if (ret == null) {
            ret = {};
          }
          if (!ret[key]) {
            ret[key] = swagger.securityDefinitions[key];
          } else {
            this.emit("warn", `multiple security definitions with the same name has define in swagger collection: ${key}`);
          }
        }
      }
    }
    return ret;
  }
  _mergedTags(swaggers) {
    let ret = [];
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.tags) {
        let ref = swagger.tags;
        for (let j = 0; j < ref.length; j++) {
          let tag = ref[j];
          if (tag && ret.indexOf(tag) < 0) {
            ret.push(tag);
          }
        }
      }
    }
    return ret;
  }
  _mergedSchemes(swaggers) {
    let ret = [];
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.schemes) {
        let ref = swagger.schemes;
        for (let j = 0; j < ref.length; j++) {
          let scheme = ref[j];
          if (scheme && ret.indexOf(scheme) < 0) {
            ret.push(scheme);
          }
        }
      }
    }
    return ret;
  }
  _mergedConsume(swaggers) {
    let ret = [];
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.consumes) {
        let ref = swagger.consumes;
        for (let j = 0; j < ref.length; j++) {
          let consume = ref[j];
          if (consume && ret.indexOf(consume) < 0) {
            ret.push(consume);
          }
        }
      }
    }
    return ret;
  };
  _mergedProduces(swaggers) {
    let ret = [];
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.produces) {
        let ref = swagger.produces;
        for (let j = 0; j < ref.length; j++) {
          let produce = ref[j];
          if (produce && ret.indexOf(produce) < 0) {
            ret.push(produce);
          }
        }
      }
    }
    return ret;
  }
  _mergedPaths(swaggers) {
    let ret = null;
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.paths) {
        let pathPrefix = '';
        if (!!swagger.basePath && swagger.basePath !== '/') {
          pathPrefix = swagger.basePath;
        }
        let ref = Object.keys(swagger.paths);
        for (let j = 0; j < ref.length; j++) {
          let key = ref[j];
          if (ret == null) {
            ret = {};
          }
          if (!ret[pathPrefix + key]) {
            ret[pathPrefix + key] = swagger.paths[key];
          } else {
            this.emit("warn", "multiple routes with the same name and base path has define in swagger collection: " + (swagger.basePath + key));
          }
        }
      }
    }
    return ret;
  }
  _mergedDefinitions(swaggers) {
    let ret = null;
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger.definitions) {
        let ref = Object.keys(swagger.definitions);
        for (let j = 0; j < ref.length; j++) {
          let key = ref[j];
          if (ret == null) {
            ret = {};
          }
          if (!ret[key]) {
            ret[key] = swagger.definitions[key];
          } else {
            this.emit("warn", "multiple definitions with the same name has define in swagger collection: " + key);
          }
        }
      }
    }
    return ret;
  }
  _mergedParameters(swaggers) {
    return this._mergedFieldObject(swaggers, 'parameters');
  }
  _mergedResponses(swaggers) {
    return this._mergedFieldObject(swaggers, 'responses');
  }
  _mergedFieldObject(swaggers, field) {
    let ret = null;
    for (let i = 0; i < swaggers.length; i++) {
      let swagger = swaggers[i];
      if (swagger[field]) {
        let ref = Object.keys(swagger[field]);
        for (let j = 0; j < ref.length; j++) {
          let key = ref[j];
          if (ret == null) {
            ret = {};
          }
          if (!ret[key]) {
            ret[key] = swagger[field][key];
          } else {
            this.emit("warn", "multiple " + field + " with the same name has define in swagger collection: " + key);
          }
        }
      }
    }
    return ret;
  }
  merge(swaggers, info, basePath, host, schemes) {
    let definitions, parameters, paths, responses, ret, securityDefinitions;
    if (typeof info !== 'object') {
      throw 'no info object as input or different format';
    }
    if (typeof basePath !== 'string') {
      throw 'no basePath string as input or different format';
    }
    if (typeof host !== 'string') {
      throw 'no host string as input or different format';
    }
    ret = {
      swagger: "2.0",
      info: info,
      host: host,
      basePath: basePath,
      schemes: schemes || this._mergedSchemes(swaggers),
      consumes: this._mergedConsume(swaggers),
      produces: this._mergedProduces(swaggers),
      tags: this._mergedTags(swaggers)
    };
    securityDefinitions = this._mergeSecurityDefinitions(swaggers);
    if (securityDefinitions) {
      ret.securityDefinitions = securityDefinitions;
    }
    definitions = this._mergedDefinitions(swaggers);
    if (definitions) {
      ret.definitions = definitions;
    }
    paths = this._mergedPaths(swaggers);
    if (paths) {
      ret.paths = paths;
    }
    parameters = this._mergedParameters(swaggers);
    if (parameters) {
      ret.parameters = parameters;
    }
    responses = this._mergedResponses(swaggers);
    if (responses) {
      ret.responses = responses;
    }
    return ret;
  }
}

const merger = new Merger()
module.exports = merger
