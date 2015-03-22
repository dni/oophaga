define [
  'cs!Oophaga'
  'jquery'
],
( Oophaga, $) ->
  class SettingsController extends Oophaga.Controller.Controller
    routes:
      "clearCache": "clearCache"
    clearCache: ->
      $.get "/clearCache", ->
        window.location = "/"
