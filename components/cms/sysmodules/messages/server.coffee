auth = require './../../lib/utilities/auth'

module.exports.setup = (app, config) ->
  Message = require("./../../lib/model/Schema")(config)

  app.get "/messages", auth, (req, res) ->
    limit = if req.query.limit? then req.query.limit else 25
    Message.find().sort(date: -1).limit(limit).execFind (arr, data) ->
      res.send data

  app.on config.moduleName+":after:post", (req, res, message)->
    req.io.broadcast "createModel", message, config.collectionName
    req.io.broadcast "message", message
