define [
  'cs!lib/Module'
  'cs!./controller/FileController'
  "i18n!./nls/language"
  "text!./configuration.json"
  'less!./style/browse.less'
],( Module, Controller, i18n, Config ) ->
  new Module
    Controller: Controller
    Config: Config
    i18n: i18n
