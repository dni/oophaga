define [
  'cs!App'
  'marionette'
  'tpl!../templates/map.html'
  'cs!./MapItemView'
], (App, Marionette, Template, MapItemView) ->


  App.map = ''
  class MapView extends Marionette.ItemView
    template: Template
    initialize:->
      @on "render", @afterRender
      # @on "destroy", -> clearInterval @interval

    afterRender:->
      @createMap()
      # console.log "lol"
      @startPositionTracking()
      # @initChildren()
      @childView = new MapItemView collection:@collection
      @$el.append @childView.render().el


    createMap:->
      el = @$el.find("#map")
      @$el.css
        height: '100%'
        width: '100%'
      App.map = new App.google.Map el.get(0),
        zoom:13
        mapTypeId: App.google.MapTypeId.HYBRID
        disableDefaultUI: true
        mapTypeControl: false
        panControl: true
        panControlOptions:
          position: App.google.ControlPosition.RIGHT_BOTTOM
        zoomControl: true,
        zoomControlOptions:
          style: App.google.ZoomControlStyle.LARGE,
          position: App.google.ControlPosition.RIGHT_BOTTOM
        scaleControl: true
        scaleControlOptions:
          position: App.google.ControlPosition.RIGHT_BOTTOM
        streetViewControl: false

    startPositionTracking:->
      pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
      setTimeout -> # ;D hacky otherwise map woulnd be correct after 2nd load
        App.map.setCenter(pos)
        App.google.event.trigger(App.map, 'resize')
        setTimeout ->
          App.map.setCenter(pos)
          App.google.event.trigger(App.map, 'resize')
        , 1000
      , 1000
      # @interval = setInterval ->
      #   console.log "nterval"
      marker = new App.google.Marker
        map: App.map,
        position: pos
      App.vent.on "newPosition", ->
        pos = new App.google.LatLng App.position.coords.latitude, App.position.coords.longitude
        marker?.setMap null
        marker = new App.google.Marker
          map: App.map,
          position: pos
      # , 5000

    # initChildren:->
    #   @findView = new MapFindsView collection: App.Finds
    #   @$el.append @findView.render().el
    #   @findsiteView = new MapFindsiteView collection: App.Findsites
    #   @$el.append @findsiteView.render().el
    #   @trackView = new MapTrackView collection: App.Tracks
    #   @$el.append @trackView.render().el

  return MapView
