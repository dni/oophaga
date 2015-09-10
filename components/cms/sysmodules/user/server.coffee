auth = require "../../lib/utilities/auth"
passport = require "passport"
User = {}

module.exports.setup = (app, config)->

  User = require('../../lib/model/Schema')(config)

  app.get "/user", auth, (req, res)->
    res.send app.user

  # login
  app.get '/login', (req, res)->
    res.sendfile process.cwd()+'/components/cms/login.html'

  app.post '/login',
    passport.authenticate('local', failureRedirect: '/login'),
    (req, res)->
      res.redirect app.config.adminroute

  app.get '/logout', (req, res)->
    req.logout()
    res.redirect '/login'

  # create default admin user if no user exists
  User.count {}, (err, count)->
    if count == 0
      admin = app.createModel "UserModule",
        email: "admin@publish.org"
        username: "admin"
        password: "password"
        title: "administrator"

      admin.save()
      console.log "admin user was created"


module.exports.localstrategy = (username, password, done) ->
  User.findOne(
    username: username
    password: password
  ).exec (err, user)->
    done err, user

module.exports.deserialize = (_id, done)->
  User.findById _id, (err, user)->
    done(err, user)

