express = require "express"

cms = express.Router()

dir = "#{process.cwd()}/components/cms"

cms.use "/", express.static dir

cms.get "/", (req, res)->
  res.sendFile "#{dir}/index.html"

module.exports = cms
