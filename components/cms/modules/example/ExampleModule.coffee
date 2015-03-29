define [
    'cs!Oophaga'
    'cs!./controller/ExampleController'
    'i18n!./nls/language.js'
    "text!./configuration.json"
], (Oophaga, Controller, i18n, Config) ->
  new Oophaga.Module
    Controller: Controller
    Config:Config
    i18n:i18n
