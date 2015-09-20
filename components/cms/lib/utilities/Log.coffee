define [
  'cs!App'
  'notify'
  'jquery'
], (App, Config, notify, $) ->

  (log, type, additionalinfo)->
    if !additionalinfo? then additionalinfo = ''
    if !type? then type = 'log'

    App.Messages.create [
      message: log
      type: type
      additionalinfo: additionalinfo
    ],
      wait:true
      success: ->
        console.log "created message", arguments
