
api = require '../routes/api'
cms = require '../routes/cms'
# upload = require '../routes/upload'

config = require "#{process.cwd()}/configuration/index.json"
metaconfig = require "#{process.cwd()}/configuration/metaAttributes.json"


moduleconfig = require './config'
models = require './models'


express = require "express"
bodyParser = require "body-parser"

passport = require 'passport'
jwt = require 'jwt-simple'

app = express()

app.use bodyParser.urlencoded extended: false
app.use bodyParser.json()
app.use passport.initialize()

# initialize configs
Object.keys(moduleconfig).forEach (key)->
  models.config.findOne namespace: moduleconfig[key].namespace, (err, module)->
    return if err or module # only if it doesnt exist
    console.log "initialize #{key} config"
    module = new models.config moduleconfig[key]
    if key is "config"
      module.metaconfig = metaconfig
    module.save()

app.use "/api/", api
# app.use "/upload/", upload
app.use config.adminroute, cms

app.post "/login", (req, res)->
  models.user.findOne username: req.body.username, (err, user)->
    if err
      res.json
        success: false
        msg: err
    if !user
      res.json
        success: false
        msg: 'Authentication failed. User not found.'
    else
      user.comparePassword req.body.password, (err, isMatch)->
        if isMatch and !err
          token = jwt.encode user, config.secret
          res.json
            success: true
            token: "JWT #{token}"
        else
          res.send
            success: false
            msg: 'Authentication failed. Wrong password.'


module.exports = app
