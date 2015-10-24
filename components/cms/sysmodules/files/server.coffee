async = require "async"
auth = require './../../lib/utilities/auth'
multiparty = require "multiparty"
fs = require "fs-extra"
dir = "./public/files/"

module.exports.setup = (app, config, setting)->
  utils = require("../../lib/utilities/fileutils.coffee")(app, setting)

  # import collection
  app.post "/import/:collectionName", auth, (req,res)->
    return "no collection name" unless req.params.collectionName?
    form = new multiparty.Form uploadDir: dir
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      async.eachSeries files['files[]'], (srcFile, done)->
        fs.unlink srcFile.path
        if srcFile.headers['content-type'] is "text/csv"
          utils.importCsv collectionName, file
      , -> res.send("done uploading")

  # upload file
  app.post "/uploadFile", auth, (req,res)->
    form = new multiparty.Form uploadDir: dir
    form.parse req, (err, fields, files)->
      if err then return console.log 'formparse error', err
      async.eachSeries files['files[]'], (srcFile, done)->
        title = utils.safeFilename srcFile.originalFilename
        fs.renameSync srcFile.path, dir+title
        file = app.createModel config.moduleName,
          "title": title
          "link": title
          "type": srcFile.headers['content-type']
        saveFile = ->
          file.save ->
            req.io.broadcast "createModel", file, config.collectionName
            done()
        if srcFile.headers['content-type'].split("/")[0] is "image"
          utils.createImages file, saveFile
        else
          saveFile()
      , -> res.send("done uploading")

  # update existing files
  app.on config.moduleName+':after:put', (req, res, file)->
    title = file.get "title"
    saveFile = ->
      file.save ->
        req.io.broadcast 'updateModel', file._id, config.collectionName
    if crop = req.body.crop
      file.set "crop", crop
      utils.cropImage file, ->
        utils.createImages file, saveFile
    else
      utils.updateFile file, saveFile

  #create new copy of the file
  app.on config.moduleName+":after:post", (req, res, file) ->
    utils.copyFile file, ->
      req.io.broadcast "createModel", file, config.collectionName

  # clean up files after model is deleted
  app.on config.moduleName+':after:delete', (req, res, file)->
    utils.deleteFile file, ->
      req.io.broadcast "destroyModel", file._id, config.collectionName
      res.end()
