define [
  'cs!App'
  'cs!Oophaga'
  'cs!./controller/UserController'
  'text!./configuration.json'
  'i18n!./nls/language.js'
], ( App, Oophaga, Controller, Config, i18n ) ->

  # $.get "/user", (user)->
  #   App.User = user

  new Oophaga.Module
    Controller: Controller
    Config: Config
    i18n: i18n
