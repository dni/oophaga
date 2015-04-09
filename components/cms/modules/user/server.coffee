auth = require "../../lib/utilities/auth"

module.exports.setup = (app, config)->
  User = require('../../lib/model/Schema')(config.dbTable)

  app.get "/user", auth, (req, res)->
    res.send app.user

  # create default admin user if no user exists
  User.count {}, (err, count)->
    if count == 0
      admin = app.createModel "UserModule"
      admin.setFieldValue
        'email': "admin@publish.org"
        'username': "admin"
        'password': "password"
        'title': "administrator"

      admin.save()
      console.log "admin user was created"
