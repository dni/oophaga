define [
  'cs!App'
  'marionette'
  'tpl!../templates/map-item.html'
], (App, Marionette, Template) ->

  class MapItemView extends Marionette.ItemView
    template: Template
    # t: i18n.attributes
    latlng: ->
      pos = @model.getLocation()
      new App.google.LatLng pos.lat, pos.lng

    modelEvents:
      "change": "updateMarker"
      "destroy": "destroyMarker"

    render: ->
      @createMarker()

    destroyMarker:->
      @marker.setMap null
      App.google.event.removeListener @listener

    updateMarker:->
      @destroyMarker()
      @createMarker()

    createMarker:->
      that = @
      @infoWindow = new App.google.InfoWindow content: @template @model.toJSON()
      @marker = new App.google.Marker
        map: App.map
        position: @latlng()
        icon:
          strokeColor: "red"
          path:App.google.SymbolPath.CIRCLE
          scale: 5
      @listener = App.google.event.addListener @marker, 'click', ->
        that.infoWindow.open App.map, that.marker
