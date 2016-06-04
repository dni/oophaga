config = require "./config"
mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

models = {}
Schema = mongoose.Schema

metaAttributes = require "#{process.cwd()}/configuration/metaAttributes.json"

Object.keys(config).forEach (module)->

  schemaObj = {}

  Object.keys(metaAttributes).forEach (key)->
    schemaObj[key] = metaAttributes[key].db

  Object.keys(config[module].modelconfig).forEach (key)->
    schemaObj[key] = config[module].modelconfig[key].db
    if config[module].modelconfig[key].db.type is "Date"
      schemaObj[key].default = Date.now

  schema = new Schema schemaObj

  if module is "user"
    schema.methods.comparePassword = (passw, cb)->
      bcrypt.compare passw, @password, (err, isMatch)->
        return cb err if err
        cb null, isMatch
    schema.pre 'save', (next)->
      user = @
      if user.isModified('password') or user.isNew
        bcrypt.genSalt 10, (err, salt)->
          return next err if err
          bcrypt.hash user.password, salt, (err, hash)->
            return next err if err
            user.password = hash
            next()
      else
        next()



  models[module] = mongoose.model config[module].dbTable, schema

  # init admin user
  if module is "user"
    models.user.findOne username: "admin", (err, user)->
      if err or !user
        admin = new models.user
        admin.title = "Admin"
        admin.username = "admin"
        admin.password = "password"
        admin.save (err)->
          console.log "admin user created"


module.exports = models
