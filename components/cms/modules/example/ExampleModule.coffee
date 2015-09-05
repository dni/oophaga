define [
    'cs!lib/Module'
    'cs!./controller/ExampleController'
    'i18n!./nls/language.js'
    "text!./configuration.json"
], (Module, Controller, i18n, Config) ->
  new Module
    Controller: Controller
    Config:Config
    i18n:i18n
