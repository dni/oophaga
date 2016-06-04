define [
  'cs!lib/Module'
  'cs!./controller/UserController'
], ( Module, Controller ) ->

  new Module
    moduleName: "UserModule"
    Controller: Controller
