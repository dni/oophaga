auth = require "./auth"

module.exports = (app, config)->
  Schema = require('./../lib/model/Schema')(config.dbTable)

  # crud
  app.post '/'+config.dbTable, auth, (req, res)->
    schema = app.createModel config.moduleName
    # do not overwrite hidden fields just update req.body fields
    Object.keys(req.body).forEach (key)->
      if key is "fields"
        Object.keys(req.body[key]).forEach (field)->
          schema[key][field].value = req.body[key][field].value
      else
        schema[key] = req.body[key]
    app.emit config.moduleName+':after:post', req, res, schema
    schema.save ->
      req.io.broadcast "createModel", schema, config.collectionName
      res.send schema

  # updated model for IO
  app.get '/'+config.dbTable+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      res.send schema

  app.get '/'+config.dbTable, auth, (req, res)->
    Schema.find().execFind (arr,data)-> res.send data

  app.put '/'+config.dbTable+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      app.emit config.moduleName+':before:put', req, res, schema
      schema.date = new Date()
      schema.user = app.user._id
      schema.fields = req.body.fields
      schema.published = req.body.published
      schema.save ->
        app.emit config.moduleName+':after:put', req, res, schema
        req.io.broadcast "updateModel", schema._id, config.collectionName
        res.send schema

  app.delete '/'+config.dbTable+'/:id', auth, (req, res)->
    Schema.findById req.params.id, (e, schema)->
      schema.remove ->
        app.emit config.moduleName+':after:delete', req, res, schema
        req.io.broadcast "destroyModel", schema._id, config.collectionName
        res.send 'deleted'
