async = require "async"
auth = require './../../lib/utilities/auth'
Setting = {}
configuration = require("../../configuration.json")
dir =  '../'
modules = configuration.backend_modules.map (moduleString)-> dir+moduleString.split("/")[1]

module.exports.setup = (app, config)->
  app.settings = {}
  Setting = require('../../lib/model/Schema')(config.dbTable)

  async.eacSeries.forEach (module)->
    console.log module
    config = require module+'/configuration.json'
    if config.settings
      Setting.findOne(title: config.moduleName).execFind (err, setting)->
        unless setting.length
          setting = app.createModel "SettingsModule",
            title: config.moduleName
            fields: config.setting
          console.log "created setting: #{config.moduleName}"
          setting.save()
        app.settings[config.moduleName] = setting[0]


  app.get "/clearCache", auth, (req, res) ->
    app.log "cleared the cache", undefined, app.user.fields.title.value

            # Setting.findOne("fields.title.value": config.moduleName).exec (err, setting)->
            #   return done setting if setting
            #   setting = app.createModel "SettingsModule", config.settings
            #   setting.fields.title = type: "type", value: config.moduleName
            #   setting.set "fieldorder", Object.keys(config.settings).splice(1)
            #   setting.save ->
            #     console.log "created Setting", setting.getFieldValue "title"
            #     done setting

