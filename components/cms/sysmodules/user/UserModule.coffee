define [
  'cs!App'
  'cs!lib/Module'
  'cs!./controller/UserController'
  'text!./configuration.json'
  'i18n!./nls/language.js'
], ( App, Module, Controller, Config, i18n ) ->

  # $.get "/user", (user)->
  #   App.User = user

  new Module
    Controller: Controller
    Config: Config
    i18n: i18n
