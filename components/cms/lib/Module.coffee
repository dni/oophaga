define [
    'cs!App'
    'cs!Router'
    "cs!./model/ControlsModel"
    'cs!lib/controller/Controller'
], ( App, Router, ControlsModel, Controller) ->
  class Module
    constructor: (args)->
      @[key] = arg for key, arg of args


    init: =>
      config = App.Configs.findWhere moduleName: @moduleName

      # set default module controller class
      @Controller = Controller unless @Controller?

      @Config = config
      @i18n = require "i18n!nls/#{config.namespace}"

      @Controller = new @Controller
        i18n: @i18n
        Config: @Config
        controls: new ControlsModel

      if @Config.controls
        @Controller.controls.set @Config.controls

      # Routes from Controller
      routes = @Controller.routes || {}

      # Standard Routes
      routes[@Config.namespace] = "defaultView"

      if @Controller.controls.get "create"
        routes[@Config.namespace+'/new/'] = "add"
        routes[@Config.namespace+'/new/:relation'] = "add"

      routes[@Config.namespace+'/filter/:filterId'] = "filter" if @Controller.controls.get "filter"
      routes[@Config.namespace+'/edit/:id'] = "edit"
      routes[@Config.namespace+'/show/:id'] = "show"
      routes[@Config.namespace+'/action/:action'] = "action"

      views = @Controller.controls.get "views"
      Object.keys(views).forEach (key)=>
        href = "#{@Config.namespace}/#{key}/"
        routes[href] = key

      @Controller.controls.set
        namespace: @Config.namespace

      Router.processAppRoutes @Controller, routes


      # collection
      if @Config.collectionName
        App[@Config.collectionName] = new @Controller.Collection
        App[@Config.collectionName].model = @Controller.Model.extend namespace: @Config.namespace
        App[@Config.collectionName].url = @Config.url
        App[@Config.collectionName].fetch
          success:->
            App.ready config.namespace
            App.vent.trigger config.namespace+":collection:ready"
      else
        App.ready @Config.namespace
