auth = require "../../lib/utilities/auth"
utils = require "../../lib/utilities/utils"

module.exports.setup = (app, config)->
  User = require('../../lib/model/Schema')(config.dbTable)

  app.get "/user", auth, (req, res)->
    res.send app.user

  # create default admin user if no user exists
  User.count {}, (err, count)->
    if count == 0
      admin = utils.createModel User, config

      admin.setFieldValue
        'email': "admin@publish.org"
        'username': "admin"
        'password': "password"
        'title': "administrator"

      admin.save()
      console.log "admin user was created"
