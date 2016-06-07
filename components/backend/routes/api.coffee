express = require "express"
api = express.Router()

models = require "../utilities/models"
checkAuth = require "../utilities/auth"
config = require "../utilities/config"
log = require "../utilities/log"

checkRoute = (req, res, cb)->
  route = req.params.route
  if route and models[route] and config[route]
    cb models[route], config[route]
  else
    res.status(404).send "Route (#{req.params.route}) not found"


api.post "/:route", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema, config)->
      schema = new Schema
      Object.keys(req.body).forEach (key)-> schema[key] = req.body[key]
      schema.cruser = user._id
      schema.user = user._id
      schema.crdate = new Date()
      schema.date = new Date()
      schema.save ->
        log req, res,
          message: "#{user.title or user.username} created new model (#{req.params.route})"
        res.app.emit "io", "create",
          model: schema
          collectionName: config.collectionName
        res.json schema

api.get "/:route", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema)->
      Schema.find().execFind (err, data)->
        res.json data

api.put "/:route/:id", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema, config)->
      Schema.findById req.params.id, (e, schema)->
        Object.keys(req.body).forEach (key)-> schema[key] = req.body[key]
        schema.date = new Date()
        schema.save ->
          log req, res,
            message: "#{user.title or user.username} updated model (#{req.params.route})"
          res.app.emit "io", "update",
            id: schema._id
            collectionName: config.collectionName
            model: user
          res.json schema

api.delete "/:route/:id", (req, res)->
  checkAuth req, res, (user)->
    checkRoute req, res, (Schema, config)->
      Schema.findById req.params.id, (e, schema)->
        schema.remove ->
          log req, res,
            type: "warn"
            message: "#{user.title or user.username} deleted model (#{req.params.route})"
          res.app.emit "io", "delete",
            id: schema._id
            collectionName: config.collectionName
          res.json
            success: true
            msg: 'deleted'

module.exports = api
