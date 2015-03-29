define [
  'jquery'
  'cs!App'
  'jquery.form'
], ($, App) ->

  $('#upload').change ->
    upload = $("#uploadFile")
    upload.ajaxForm (response) ->
    upload.submit()

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
