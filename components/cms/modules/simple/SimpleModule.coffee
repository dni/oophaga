define [
    'cs!Oophaga'
    'i18n!./nls/language.js'
    "text!./configuration.json"
], (Oophaga, i18n, Config) ->
  new Oophaga.Module
    Config:Config
    i18n:i18n
