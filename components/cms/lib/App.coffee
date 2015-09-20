define [
  'googlemaps!'
  'marionette'
  'cs!lib/view/AppLayoutView'
  'text!configuration'
  'io'
  'jquery'
  'jquery.form'
], (google, Marionette, AppLayout, configuration, io, $) ->
  modules = JSON.parse(configuration).backend_modules
  count = Object.keys(JSON.parse(configuration).backend_modules)

  new Marionette.Application

    modules: {}

    init: ->
      @view = new AppLayout
      $('body').append @view.render().el
      require modules, ->
        modules = arguments
        Object.keys(modules).forEach (key)->
          module = modules[key]
          module.init()


    ready:(moduleName)->
      count.pop()
      if !count.length
        @startGeoTracking()
        @initUpload()
        @initSocket()
        @vent.trigger "ready"

    google: google
    position:
      coords:
        accuracy: 13976
        altitude: null
        altitudeAccuracy: null
        heading: null
        latitude: 48.2311483
        longitude: 13.939873299999999
        speed: null
      timestamp: Date.now()

    startGeoTracking: ->
      that = this
      if navigator.geolocation
        setInterval ->
          navigator.geolocation.getCurrentPosition (position)->
            that.position = position
            that.vent.trigger "newPosition"
        , 3000

    initUpload: ->
      $('#upload').change ->
        console.log "change"
        upload = $("#uploadFile")
        upload.ajaxForm (response) ->
        upload.submit()
    initSocket: ->

      @socket = io.connect()

      @socket.on "message", (msg, type)->
        msgType = "success"
        msgType = "info" if type is "message"
        msgType = "warn" if type is "delete"
        $.notify msg,
          className: msgType
          position:"right bottom"

      @socket.on "updateModel", (id, collectionName)=>
        model = @[collectionName].get id
        model.fetch() unless model.hasChanged()

      @socket.on "createModel", (model, collectionName)=>
        @[collectionName].add model

      @socket.on "destroyModel", (id, collectionName)=>
        model = @[collectionName].remove id

      @socket.on "disconnect", ->
        # reload page for new login after server restarts/crashed
        reload = -> document.location.reload()
        setTimeout reload, 3000

      @socket.on "connect", ->
        console.log "socket connected"
        # $.get "/user", (user)->
        #   App.User = new Model user

      @socket.on "error", (err)->
        console.log "SOCKET ERROR: " + err
