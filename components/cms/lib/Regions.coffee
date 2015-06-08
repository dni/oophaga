define [
  'jquery'
  'cs!App'
  'jquery.form'
], ($, App) ->

  App.vent.on "ready", ->
    $('#upload').change ->
      console.log "change"
      upload = $("#uploadFile")
      upload.ajaxForm (response) ->
      upload.submit()

  App.addRegions
    navigationRegion:"#navbar"
    contentRegion:"#content"
    detailRegion:"#details"
    infoRegion:"#info"
    overlayRegion: "#overlay"
    listTopRegion: "#controls"
