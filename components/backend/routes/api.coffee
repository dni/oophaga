express = require "express"
api = express.Router()

models = require "../utilities/models"
checkAuth = require "../utilities/auth"

checkRoute = (req, res, cb)->
  if req.params.route and models[req.params.route]
    cb models[req.params.route]
  else
    res.status(404).send "Route (#{req.params.route}) not found"


api.post "/:route", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema)->
      schema = new Schema
      Objects.keys(req.body).forEach (key)-> schema[key] = req.body[key]
      schema.cruser = user._id
      schema.user = user._id
      schema.crdate = new Date()
      schema.date = new Date()
      schema.save ->
        res.app.emit "io", "create", schema, user
        res.json schema

api.get "/:route", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema)->
      Schema.find().execFind (err, data)->
        res.json data

api.put "/:route/:id", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema)->
      Schema.findById req.params.id, (e, schema)->
        Object.keys(req.body).forEach (key)-> schema[key] = req.body[key]
        schema.date = new Date()
        schema.save ->
          res.app.emit "io", "update", schema._id, user
          res.send schema

api.delete "/:route/:id", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema)->
      Schema.findById req.params.id, (e, schema)->
        schema.remove ->
          res.app.emit "io", "delete", schema._id, user
          res.json
            success: true
            msg: 'deleted'

module.exports = api
