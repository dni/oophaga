define [
  'cs!lib/controller/Controller'
  'cs!../view/ShowSettingView.coffee'
  'cs!../view/EditSettingView.coffee'
  'jquery'
],
( Controller, ShowSettingView, EditSettingView, $) ->
  class SettingsController extends Controller

    ShowView: ShowSettingView
    EditView: EditSettingView

    routes:
      "clearCache": "clearCache"

    clearCache: ->
      $.get "/clearCache", ->
        window.location = "/"
