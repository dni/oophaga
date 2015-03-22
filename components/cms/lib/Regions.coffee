define [
  'cs!App'
], (App) ->


  App.addRegions
    navigationRegion:"#navigation"
    contentRegion:"#content"
    detailRegion:"#details"
    infoRegion:"#info"
    overlayRegion: "#overlay"
    listTopRegion: "#controls"

  # close detailview if now listview is shown
  App.contentRegion.on "show", ->
    if App.detailRegion.currentView? then App.detailRegion.currentView.destroy()
