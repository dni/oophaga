define [
    'cs!lib/Module'
    'i18n!./nls/language.js'
    "text!./configuration.json"
], (Module, i18n, Config) ->
  new Module
    Config:Config
    i18n:i18n
