define [
  'googlemaps!'
  'marionette'
  'cs!lib/view/AppLayoutView'
  'text!configuration'
  'jquery'
  'jquery.form'
], (google, Marionette, AppLayout, configuration, $) ->
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
        @vent.trigger "ready"

    google: google
    position:
      coords:
        accuracy: 13976
        altitude: null
        altitudeAccuracy: null
        heading: null
        latitude: 0
        longitude: 0
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
