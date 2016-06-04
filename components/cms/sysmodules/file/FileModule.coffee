define [
  'cs!lib/Module'
  'cs!./controller/FileController'
],( Module, Controller ) ->
  new Module
    moduleName: "FileModule"
    Controller: Controller
