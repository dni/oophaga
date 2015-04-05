define [
  'cs!App'
  'cs!./model/Model'
  'cs!Utils'
  'io'
], (App, Model, Utils, io ) ->

  socket = io.connect()
  socket.on "message", (msg, type)->
    msgType = "success"
    msgType = "info" if type is "message"
    msgType = "warn" if type is "delete"
    $.notify msg,
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
