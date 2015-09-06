define [
  'cs!App'
  'marionette'
  'cs!./MapItemView'
], (App, Marionette, MapItemView) ->

  class MapListView extends Marionette.CollectionView
    childView: MapItemView
