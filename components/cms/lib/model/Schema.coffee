mongoose = require 'mongoose'
_ = require "underscore"
Schema = mongoose.Schema
collections = {}
metaAttributes = require "../utilities/meta-attributes.json"

module.exports = (config)->

  # require schema with config.dbTable after first init
  if typeof config is "string"
    return throw new Error "schema not initialized" unless collections[config]?
    return collections[config]

  unless collections[config.dbTable]?
    schemaObj = {}
    Object.keys(metaAttributes).forEach (key)->
      schemaObj[key] = metaAttributes[key].db or "String"
    Object.keys(config.model).forEach (key)->
      schemaObj[key] = config.model[key].db or "String"
    collections[config.dbTable] = mongoose.model config.dbTable, new Schema schemaObj

  collections[config.dbTable]
