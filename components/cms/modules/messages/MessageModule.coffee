define [
    'cs!Oophaga'
    'cs!./controller/MessageController'
    "text!./configuration.json"
    "i18n!./nls/language.js"
    'less!./style'
],
( Oophaga, Controller, Config, i18n ) ->

  new Oophaga.Module
    Config: Config
    i18n: i18n
