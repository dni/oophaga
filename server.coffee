config = require "./configuration.json"

port = process.argv[2] || config.port
sessionSecret = 'oophaga#isla#colon'

express = require 'express.io'
app = express()
app.config = config
mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/'+config.dbname
fs = require 'fs'
auth = require "./components/cms/lib/utilities/auth"
passport = require "passport"
LocalStrategy = require('passport-local').Strategy
UserModule = require "./components/cms/modules/user/server.coffee"

app.http().io()


app.configure ->

  #prerenderer for seo
  # app.use require 'prerender-node'
  app.use '/public', express.static 'public'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.session secret: sessionSecret
  app.use passport.initialize()
  app.use passport.session()
  passport.use new LocalStrategy UserModule.localstrategy
  passport.deserializeUser UserModule.deserialize
  passport.serializeUser (user, done)-> done null, user._id



#admin route
app.get config.adminroute, auth, (req, res)->
  app.user = req.user
  dir = '/components/cms/'
  dir = '/cache/build/cms/' if port is config.port
  app.use '/', express.static process.cwd()+dir
  res.sendfile process.cwd()+dir+'/index.html'

# load/setup components
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

app.listen port
console.log "Welcome to Oophaga CMS, quack! server runs on port "+port
