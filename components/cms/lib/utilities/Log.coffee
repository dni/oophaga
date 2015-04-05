define [
  'require'
  'cs!lib/model/Model'
  'text!modules/messages/configuration.json'
  'notify'
  'jquery'
], (require, Model, Config, notify, $) ->
  config = JSON.parse Config
  (log, type, additionalinfo)->
    if !additionalinfo? then additionalinfo = ''
    if !type? then type = 'log'

    App = require "cs!App"
    username = App.User.get "_id"

    config.model.message.value =  log
    config.model.user.value = username
    config.model.type.value = type
    config.model.additionalinfo.value = additionalinfo

    message = new Model
    message.set "name", "MessageModel"
    message.set "fields", config.model
    App.Messages.create message,
      success: ->

    message
