define [
  'cs!Oophaga'
  'cs!./controller/FileController'
  "i18n!./nls/language.js"
  "text!./configuration.json"
  'less!./style/browse.less'
],( Oophaga, Controller, i18n, Config ) ->
  new Oophaga.Module
    Controller: Controller
    Config: Config
    i18n: i18n
