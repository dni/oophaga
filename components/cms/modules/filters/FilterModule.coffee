define [
  'cs!App'
  'cs!lib/Module'
  "text!./configuration.json"
  "i18n!./nls/language.js"
  'cs!./controller/FilterController'
], ( App, Module, Config, i18n, Controller ) ->

  new Module
    Controller: Controller
    Config: Config
    i18n: i18n
