auth = require "./auth"
app = require "./appserver"
csv = require "csv"
_ = require "underscore"

module.exports = (config)->
  Schema = require('./../model/Schema')(config)

  # public data
  app.get '/data/'+config.dbTable, (req, res)->
    Schema.find(published:true).execFind (arr,data)-> res.send data

  # crud
  app.post '/'+config.dbTable, auth, (req, res)->
    schema = app.createModel config.moduleName, req.body
    app.emit config.moduleName+':after:post', req, res, schema
    schema.save ->
      schema.name = config.moduleName
      app.log schema, "create"
      req.io.broadcast "createModel", schema, config.collectionName
      res.send schema

  # updated model for IO
  app.get '/'+config.dbTable+'/:id', auth, (req, res)->
    if req.params.id is "export"
      res.setHeader('Content-disposition', 'attachment; filename=#{config.dbTable}-export.csv')
      res.contentType('csv')
      Schema.find().execFind (err, data)->
        columns = _.map data[0], (d)->
          obj = {}
          obj[d] = d
          obj
        csv.stringify data, {header:true, columns:columns}, (err, csvData)->
          console.log csvData
          res.send csvData
    else
      Schema.findById req.params.id, (e, schema)->
        res.send schema

  app.get '/'+config.dbTable, auth, (req, res)->
    Schema.find().execFind (arr,data)-> res.send data

  app.put '/'+config.dbTable+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      app.emit config.moduleName+':before:put', req, res, schema
      Object.keys(req.body).forEach (key)-> schema[key] = req.body[key]
      schema.date = new Date()
      schema.user = req.user._id
      schema.published = req.body.published
      schema.save ->
        app.emit config.moduleName+':after:put', req, res, schema
        schema.name = config.moduleName
        app.log schema, "update"
        req.io.broadcast "updateModel", schema._id, config.collectionName
        res.send schema

  app.delete '/'+config.dbTable+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      schema.remove ->
        app.emit config.moduleName+':after:delete', req, res, schema
        schema.name = config.moduleName
        if config.moduleName isnt "MessagesModule"
          app.log schema, "delete"
        req.io.broadcast "destroyModel", schema._id, config.collectionName
        res.send 'deleted'
