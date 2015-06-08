async = require "async"
csv = require "csv"
gm = require 'gm'
fs = require "fs-extra"
dir = "./public/files/"
types = ["bigPic", "smallPic", "thumbnail"]


module.exports = (app, setting)->

  safeFilename: (name)->
    title = name
      .replace(/\./g, '-')
      .replace(/\-(?=[^-]*$)/, '.')
      .replace(/\ /g, '_')
    if fs.existsSync(dir+title)
      title = title.replace /\.(?=[^.]*$)/, "_"+Date.now()+"_copy."
    return title

  prependFilename: (link, text)->
    # replace last dot in filename
    link.replace /\.(?=[^.]*$)/, '_'+text+'.'

  isImage: (file)-> file.type.split("/")[0] is "image"

  deleteFile: (file, done)->
    return if file?
    if fs.exists dir+file.title
      fs.unlinkSync dir+file.title
    if @isImage file
      for type in types
        if fs.exists dir+file[type]
          fs.unlinkSync dir+file[type]

  createImages: (file, done)->
    that = @
    filename = file.title
    quality = parseInt app.settings.FileModule.fields.quality.value
    image = gm(dir+filename).size (err, size) ->
      return console.log("gm error, probably no gm and im installed") if err
      portrait = size.width < size.height
      async.each types, (type, cb)->
        maxSize = parseInt app.settings.FileModule.fields[type].value
        targetName = that.prependFilename filename, type
        file[type] = targetName
        image.quality quality
        if portrait then image.resize null, maxSize
        else image.resize maxSize
        image.write dir+targetName, cb
      , done


  updateFile: (file, done)=>
    title = file.link
    link = file.link
    if title != link
      safe = @safeFilename link
      file.title = safe
      @moveFile file, done

  copyFile: (file, done)->
    oldLink = file.link
    newLink = @prependFilename oldLink, 'child'
    fs.writeFileSync dir+newLink, fs.readFileSync(dir+oldLink)
    if @isImage file
      for type in types
        oldLink = file[type]
        newLink = @prependFilename oldLink, 'child'
        fs.writeFileSync dir+newLink, fs.readFileSync(dir+oldLink)
    done()


  # improveable
  moveFile: (file, done)->
    oldLink = file.link
    newLink = @prependFilename oldLink, 'child'
    fs.renameSync dir+oldLink, dir+newLink
    if @isImage file
      for type in types
        oldLink = file[type]
        newLink = @prependFilename oldLink, 'child'
        fs.renameSync dir+oldLink, dir+newLink
    done()

  cropImage: (file, done)->
    gmImg = gm(dir+file.title)
    crop = file.get "crop"
    gmImg.size (err, size)->
      return if err
      ratio = size.width / crop.origSize.w
      gmImg.crop(crop.w*ratio, crop.h*ratio, crop.x*ratio, crop.y*ratio)
      gmImg.write dir+title, done


  importCsv: (file, done)->
    importFailed = "import failed "
    csvLink = dir+file.link
    input = fs.readFileSync(csvLink).toString()
    collectionName = file.link.split(".").shift().split('_').shift()
    config = app.collections[collectionName]
    return app.log importFailed+"collection: "+collectionName+" doesnt exist.", "error" unless config?
    csv.parse input, {delimiter: ";"}, (err, data)->
      fields = data.shift()
      async.eachSeries data, (row, cb)->
        model = app.createModel config.moduleName
        async.eachSeries fields, (field, cb2)->
          j = fields.indexOf(field)
          modelField = config.model[field]
          return app.log importFailed+field+" doesnt exist in config.", "error" unless modelField?
          if modelField.collection?
            Collection = require("../lib/model/Schema")(modelField.collection)
            Collection.findOne("fields.title.value": row[j]).exec (err, submodel)->
              return app.log importFailed+field+" with title: " + row[j] + " doesnt exist.", "warn" unless submodel?
              value = submodel.get "id"
              model[field] = value
              cb2()
          else
            value = row[j]
            model[field] =  value
            cb2()
        , -> model.save cb
      , ->
        app.log "import success, created " + data.length + " rows from " + collectionName + ".", "new"
        app.io.broadcast "updateCollection", collectionName
        done()

