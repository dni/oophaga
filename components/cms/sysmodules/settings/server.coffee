async = require "async"
auth = require './../../lib/utilities/auth'
Setting = {}
configuration = require("../../configuration.json")
modules = configuration.backend_modules.map (moduleString)->
  "#{process.cwd()}/components/cms/#{moduleString.split("/")[0].split("!")[1]}/#{moduleString.split("/")[1]}"

module.exports.setup = (app, config)->
  app.settings = {}
  Setting = require('../../lib/model/Schema')(config.dbTable)

  async.eachSeries modules, (module, done)->
    config = require module+'/configuration.json'
    return done() unless config.settings?
    Setting.findOne(title: config.moduleName).execFind (err, setting)->
      unless setting.length
        newsetting = app.createModel "SettingsModule",
          title: config.moduleName
          fields: config.settings
        console.log "created setting: #{config.moduleName}"
        newsetting.save ->
          app.settings[config.moduleName] = newsetting
          done()
      else
        app.settings[config.moduleName] = setting[0]
        done()


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

