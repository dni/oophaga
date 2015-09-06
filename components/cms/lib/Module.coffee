define [
    'cs!App'
    'cs!Router'
    "cs!./model/ControlsModel"
    'cs!lib/controller/Controller'
], ( App, Router, ControlsModel, Controller) ->
  class Module
    constructor: (args)->
      @[key] = arg for key, arg of args


    init:=>
      return throw new Error "no module config" unless @Config?
      return throw new Error "no module i18n" unless @i18n?
      unless @Controller? then @Controller = Controller

      if typeof @Config is "string"
        @Config = JSON.parse @Config

      config = @Config

      App.modules[config.moduleName] = config

      @Controller = new @Controller
        i18n: @i18n
        Config: @Config
        controls: new ControlsModel

      if @Config.controls
        @Controller.controls.set @Config.controls

      # Routes from Controller
      routes = @Controller.routes || {}

      # Standard Routes
      routes[@Config.moduleName] = "defaultView"

      if @Controller.controls.get "create"
        routes[@Config.moduleName+'/new/'] = "add"
        routes[@Config.moduleName+'/new/:relation'] = "add"

      routes[@Config.moduleName+'/filter/:filterId'] = "filter" if @Controller.controls.get "filter"
      routes[@Config.moduleName+'/edit/:id'] = "edit"
      routes[@Config.moduleName+'/show/:id'] = "show"
      routes[@Config.moduleName+'/action/:action'] = "action"
      routes[@Config.moduleName+'/remove/'] = "removeSelected"
      routes[@Config.moduleName+'/export/'] = "exportSelected"

      views = @Controller.controls.get "views"
      Object.keys(views).forEach (key)=>
        href = "#{@Config.moduleName}/#{key}/"
        routes[href] = key

      @Controller.controls.set
        moduleName: @Config.moduleName

      Router.processAppRoutes @Controller, routes


      # collection
      if @Config.collectionName
        App[@Config.collectionName] = new @Controller.Collection
        App[@Config.collectionName].model = @Controller.Model.extend moduleName: @Config.moduleName
        App[@Config.collectionName].url = @Config.url
        App[@Config.collectionName].fetch
          success:->
            App.ready config.moduleName
            App.vent.trigger config.moduleName+":collection:ready"
      else
        App.ready @Config.moduleName


      if config.settings
        App.vent.trigger 'SettingsModule:translate', @i18n

      if config.navigation
        App.vent.trigger 'CmsModule:addNavItem',
          navigation:config.navigation
          route: config.moduleName
        , @i18n
