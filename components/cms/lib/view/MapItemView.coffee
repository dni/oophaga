define [
  'cs!App'
  'marionette'
  'tpl!../templates/map-item.html'
], (App, Marionette, Template) ->

  map = ''
  class ListItemView extends Marionette.ItemView
    template: Template
    # t: i18n.attributes
    latlng: ->
      pos = @model.getLocation()
      new App.google.LatLng pos.lat, pos.lng

    initialize:->
      # @updateRelations()

    # updateRelations:->
    #   @category = App.Categories.findWhere _id: @model.getValue 'category'
    #   @subcategory = App.Subcategories.findWhere _id: @model.getValue 'subcategory'

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
      # @updateRelations()
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

  class ListView extends Marionette.CollectionView
    childView: ListItemView
