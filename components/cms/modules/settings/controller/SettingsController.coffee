define [
  'cs!Oophaga'
  'cs!../view/ShowSettingView.coffee'
  'jquery'
],
( Oophaga, ShowSettingView, $) ->
  class SettingsController extends Oophaga.Controller.Controller

    ShowView: ShowSettingView
    routes:
      "clearCache": "clearCache"
    clearCache: ->
      $.get "/clearCache", ->
        window.location = "/"
