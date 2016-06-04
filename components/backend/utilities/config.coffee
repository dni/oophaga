fs = require "fs"

modulesDir = "#{process.cwd()}/configuration/modules/"
modules = {}

files = fs.readdirSync modulesDir

files.forEach (file)->
  name = file.split(".")[0]
  modules[name] = require modulesDir+name

module.exports = modules
