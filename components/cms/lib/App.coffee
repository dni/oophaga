define [
  'googlemaps!'
  'marionette'
  'cs!lib/view/AppLayoutView'
  'cs!lib/view/LoginView'
  'cs!lib/model/Collection'
  'io'
  'cs!lib/utilities/cookie'
  'jquery'
  'jquery.form'
], (google, Marionette, AppLayout, LoginView, Collection, io, cookie, $) ->

  new Marionette.Application

    count: 0

    init: ->
      if cookie.read "token"
        @initApp()
      else
        loginview = new LoginView
        $('body').html loginview.render().el

    initApp: ->
      @view = new AppLayout
      $('body').html @view.render().el
      @NavItems = new Backbone.Collection
      @Configs = new Collection
      @Configs.url = "/api/config/"
      @Configs.fetch
        success:=>
          @count = @Configs.models.length
          modules = @Configs.map (config)->
            config.get "path"
          require modules, ->
            loadedmodules = arguments
            Object.keys(loadedmodules).forEach (key)->
              loadedmodules[key].init()

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

      @socket.on "message", (args)->
        msgType = "success"
        msgType = "info" if args.type is "message"
        msgType = "warn" if args.type is "delete"
        $.notify args.msg,
          className: msgType
          position:"right bottom"

      @socket.on "updateModel", (args)=>
        model = @[args.collectionName].get args.id
        if model
          model.fetch dataType: "jsonp" unless model.hasChanged()

      @socket.on "createModel", (args)=>
        @[args.collectionName].add args.model

      @socket.on "destroyModel", (args)=>
        model = @[args.collectionName].get args.id
        if model
          model.remove()

      @socket.on "disconnect", ->
        console.log "socket disconnected"

      @socket.on "connect", ->
        console.log "socket connected"

      @socket.on "error", (err)->
        console.log "socket err: #{err}"
