jwt = require "jwt-simple"
config = require "#{process.cwd()}/configuration/index.json"
models = require "./models"

getToken = (headers)->
  if headers and headers.authorization
    parted = headers.authorization.split ' '
    if parted.length is 2
      return parted[1]
    else
      return null
  else
    return null


module.exports = (req, res, cb)->
  token = getToken req.headers
  if token
    decoded = jwt.decode token, config.secret
    models.user.findOne username: decoded.username, (err, user)->
      if err
        res.status(403).send
          success: false
          msg: err
      if (!user)
        res.status(403).send
          success: false
          msg: 'Authentication failed. User not found.'
      else
        cb user
  else
    res.status(403).send
      success: false
      msg: 'No token provided.'

