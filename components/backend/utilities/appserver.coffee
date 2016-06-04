
api = require './routes/api'
# cms = require './routes/cms'
# upload = require './routes/upload'

config = require "#{process.cwd()}/configuration/index"

models = require './utilities/models'


express = require "express"
app = express()


app.use "/api/", api
# app.use "/upload/", upload
# app.use config.adminroute, cms

app.post "/login", (req, res)->
  console.log "everything delteed"


module.exports.setup = app

