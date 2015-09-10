fs = require 'fs'
crud = require './lib/utilities/crud'
SettingsModule = require "./sysmodules/settings/server.coffee"
configuration = require("./configuration.json")
modules = configuration.backend_modules.map (moduleString)->
  "#{__dirname}/#{moduleString.split("/")[0].split("!")[1]}/#{moduleString.split("/")[1]}/"

module.exports.setup = (app)->

  app.modules = {}
  app.collections = {}

  app.createModel = (moduleName, fields)->
    config = app.modules[moduleName].config
    Schema = require('./lib/model/Schema')(config.dbTable)
    schema = new Schema
    # ? is important for admin creation
    schema.cruser = app.user?._id
    schema.user = app.user?._id
    schema.crdate = new Date()
    schema.date = new Date()
    schema.published = false
    schema.relation = ""
    schema.name = config.modelName
    Object.keys(fields).forEach (key)->
      schema[key] = fields[key]
    return schema

  app.log = (model, type)->
    return if model.name is "Message" # dont log yourself ;)
    if !type? then type = 'log'
    if !name? then name = 'System'
    additionalinfo =
      href: "##{model.name}/#{model._id}"
    msg = "#{app.user.title}: #{type}, #{model.name}"
    message = app.createModel 'MessagesModule',
      name: app.user.title
      message: msg
      type: type
      additionalinfo: additionalinfo
    message.save ->
      app.io.broadcast "createModel", message, "Messages"
      app.io.broadcast "message", msg, type

  app.configure ->
    # load/setup modules
    modules.forEach (module)->
      fs.exists module+'/server.coffee', (exists)->
        if exists
          module_server = require module+'/server.coffee'
          config = require module+'/configuration.json'
          if config.collectionName
            app.collections[config.collectionName] = config # important for import
            crud config
          app.modules[config.moduleName] = config: config
          module_server.setup app, config
