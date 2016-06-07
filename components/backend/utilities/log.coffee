
models = require "./models"

module.exports = (req, res, args)->

  res.app.emit "io", "message",
    msg: args.message

  # dont log yourself
  if req.params.route isnt "message"
    model = new models.message args
    model.crdate = new Date
    model.date = new Date
    model.save ->
      res.app.emit "io", "create",
        model: model
        collectionName: "Messages"
