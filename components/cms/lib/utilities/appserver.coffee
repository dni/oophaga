express = require 'express.io'
passport = require "passport"
LocalStrategy = require('passport-local').Strategy
UserModule = require "../../modules/user/server.coffee"
app = express()
app.http().io()
app.configure ->
  #prerenderer for seo
  # app.use require 'prerender-node'
  app.use '/public', express.static 'public'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.cookieParser()
  app.use express.session secret: 'oophaga#isla#colon'
  app.use passport.initialize()
  app.use passport.session()
  passport.use new LocalStrategy UserModule.localstrategy
  passport.deserializeUser UserModule.deserialize
  passport.serializeUser (user, done)-> done null, user._id

module.exports = app
