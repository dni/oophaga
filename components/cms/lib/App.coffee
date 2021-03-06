define [
  'googlemaps!'
  'marionette'
  'cs!lib/view/AppLayoutView'
  'cs!lib/view/LoginView'
  'cs!lib/model/Collection'
  'io'
  'cs!lib/utilities/cookie'
  'jquery'
  'notify'
  'jquery.form'
], (google, Marionette, AppLayout, LoginView, Collection, io, cookie, $, notify) ->

  new Marionette.Application

    count: 1337

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
          @SysConfig = @Configs.findWhere namespace: "config"
          modules = @Configs.map (config)->
            config.get "path"
          require modules, ->
            loadedmodules = arguments
            Object.keys(loadedmodules).forEach (key)->
              loadedmodules[key].init()

    ready:->
      @count--
      if @count is 0
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
      that = @
      if navigator.geolocation
        setInterval ->
          navigator.geolocation.getCurrentPosition (position)->
            that.position = position
            that.vent.trigger "newPosition"
        , 3000

    initUpload: ->
      $('#upload').change ->
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

      @socket.on "update", (args)=>
        model = @[args.collectionName].get args.id
        if model
          model.fetch dataType: "jsonp" unless model.hasChanged()

      @socket.on "create", (args)=>
        @[args.collectionName].add args.model

      @socket.on "destroy", (args)=>
        model = @[args.collectionName].get args.id
        if model
          model.remove()

      @socket.on "disconnect", ->
        console.log "socket disconnected"

      @socket.on "connect", ->
        console.log "socket connected"

      @socket.on "error", (err)->
        console.log "socket err: #{err}"
