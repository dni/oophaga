define [
    'cs!lib/Module'
    'cs!./controller/MessageController'
    "text!./configuration.json"
    "i18n!./nls/language.js"
    'less!./style'
],
( Module, Controller, Config, i18n ) ->

  new Module
    Config: Config
    i18n: i18n
