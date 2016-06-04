express = require "express"
api = express.Router()


api.get "/", (req, res)->
  res.send "hello"

module.exports = api
