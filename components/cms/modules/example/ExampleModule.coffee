define [
    'cs!lib/Module'
    'cs!./controller/ExampleController'
], (Module, Controller) ->
  new Module
    moduleName: "ExampleModule"
    Controller: Controller
