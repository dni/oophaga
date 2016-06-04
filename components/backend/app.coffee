mongoose = require "mongoose"
app = require "./utilities/appserver"

config = require "#{process.cwd()}/configuration/index.json"

module.exports = (cb)->

  # start the server
  server = app.listen config.port, ->
    mongoose.connect "mongodb://localhost/#{config.dbname}"
    server.on "close", ->
      mongoose.connection.close()
    mongoose.connection.once "open", ->
      cb?(config.port)

    # io = require("socket.io") server
    # io.on "connection", (socket)->
    #   app.on "io", (eventname, args)->
    #     socket.emit eventname, args
