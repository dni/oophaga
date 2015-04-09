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
    subnavigationRegion:"#subnav-buttons"
    contentRegion:"#content"
    detailRegion:"#details"
    infoRegion:"#info"
    overlayRegion: "#overlay"
    listTopRegion: "#controls"
