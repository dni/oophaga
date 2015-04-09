config = require "./configuration.json"

port = process.argv[2] || config.port
sessionSecret = 'oophaga#isla#colon'

express = require 'express.io'
app = express()
app.config = config
passport = require "passport"
LocalStrategy = require('passport-local').Strategy
mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/'+config.dbname
fs = require 'fs'
User = require(__dirname+"/components/cms/lib/model/Schema")("users")
auth = require "./components/cms/lib/utilities/auth"

app.http().io()


app.configure ->

  #prerenderer for seo
  # app.use require 'prerender-node'

  #authentication
  passport.use new LocalStrategy (username, password, done) ->
    User.findOne(
      'fields.username.value': username
      'fields.password.value': password
    ).execFind (err, user)->
      app.user = user[0]
      done err, user[0]

  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (_id, done)->
    User.findById _id, (err, user)->
      if !err then app.user = user
      done(err, user)

  app.use '/public', express.static 'public'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.session secret: sessionSecret
  app.use passport.initialize()
  app.use passport.session()


# login
app.get '/login', (req, res)->
  res.sendfile process.cwd()+'/components/cms/login.html'

app.post '/login', passport.authenticate('local', failureRedirect: '/login'), (req, res)->
  res.redirect config.adminroute

app.get '/logout', (req, res)->
  req.logout()
  res.redirect '/login'

#admin route
app.get config.adminroute, auth, (req, res)->
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
