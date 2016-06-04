#load/setup components
modulesDir = "#{process.cwd()}/configuration/modules/"
modules = {}
fs.readdirSync modulesDir, (err, files)->
  files.forEach (file)->
    name = file.split(".")[0]
    modules[name] = require modulesDir+name

module.exports = modules
