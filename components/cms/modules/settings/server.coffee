async = require "async"
auth = require './../../lib/utilities/auth'
module.exports.setup = (app, config)->

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
