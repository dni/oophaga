express = require 'express.io'
mongoose = require "mongoose"
fs = require 'fs'
auth = require "./components/cms/lib/utilities/auth"
app = require "./components/cms/lib/utilities/appserver"

module.exports = (config, cb)->

  app.config = config

  #admin route
  app.get app.config.adminroute, auth, (req, res)->
    app.user = req.user
    dir = '/components/cms/'
    dir = '/cache/build/cms/' if config.production
    app.use '/', express.static process.cwd()+dir
    res.sendfile process.cwd()+dir+'/index.html'

  #load/setup components
  componentsDir = __dirname+'/components/'
  fs.readdir componentsDir, (err, files)->
    if err then throw err
    files.forEach (file)->
      fs.lstat componentsDir+file, (err, stats)->
        if !err && stats.isDirectory()
          fs.exists componentsDir+file+'/server.coffee', (exists)->
            if exists
              component = require componentsDir+file+'/server.coffee'
              component.setup app, config

  port = process.argv[2] || config.port
  server = app.listen config.port, ->
    mongoose.connect 'mongodb://localhost/'+config.db
    server.on "close", ->
      mongoose.connection.close()
    mongoose.connection.once "open", ->
      cb?()
