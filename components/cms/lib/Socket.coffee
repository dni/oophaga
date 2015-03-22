define [
  'cs!App'
  'cs!./model/Model'
  'cs!Utils'
  'io'
], (App, Model, Utils, io ) ->

  socket = io.connect()
  socket.on "message", (msg)->
    msg = msg.fields
    msgType = ""
    msgText = msg.name.value+" "+msg.message.value
    if msg.type.value is "update" or msg.type.value is "message" then msgType = "info"
    else if msg.type.value is "delete" then msgType = "warn"
    else if msg.type.value is "new" then msgType = "success"
    else msgType = "success"
    #else if msgType is "error" then msgType = "error"
    $.notify msgText,
      className: msgType
      position:"right bottom"

  socket.on "updateModel", (id, collectionName)->
    model = App[collectionName].get id
    model.fetch() unless model.hasChanged()

  socket.on "createModel", (model, collectionName)->
    App[collectionName].add model

  socket.on "destroyModel", (id, collectionName)->
    model = App[collectionName].remove id

  socket.on "disconnect", ->
    # reload page for new login after server restarts/crashed
    reload = -> document.location.reload()
    setTimeout reload, 3000

  socket.on "connect", ->
    $.get "/user", (user)->
      App.User = new Model user

  socket.on "error", (err)->
    Utils.Log "SOCKET ERROR: " + err
