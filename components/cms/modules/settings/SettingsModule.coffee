define [
  'cs!App'
  'cs!Oophaga'
  "text!./configuration.json"
  "i18n!./nls/language.js"
  'cs!./controller/SettingsController'
], ( App, Oophaga, Config, i18n, Controller ) ->

  module = new Oophaga.Module
    Controller: Controller
    Config: Config
    i18n: i18n

  App.vent.on "SettingsModule:translate", (lang)->
    for key, value of lang.attributes
      module.i18n.attributes[key] = value

  module
