express = require "express"

cms = express.Router()

dir = "#{process.cwd()}/components/cms/"

cms.get app.config.cmsroute, (req, res)->
  app.use '/', express.static process.cwd()+dir
  res.sendfile "#{process.cwd()}#{dir}/index.html"

module.exports = cms
