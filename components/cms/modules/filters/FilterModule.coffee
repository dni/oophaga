define [
  'cs!App'
  'cs!Oophaga'
  "text!./configuration.json"
  "i18n!./nls/language.js"
  'cs!./controller/FilterController'
], ( App, Oophaga, Config, i18n, Controller ) ->

  new Oophaga.Module
    Controller: Controller
    Config: Config
    i18n: i18n
