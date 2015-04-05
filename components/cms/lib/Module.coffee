define [
    'cs!App'
    'cs!Router'
    'cs!lib/controller/Controller'
], ( App, Router, Controller) ->
  class Module
    constructor: (args)->
      @[key] = arg for key, arg of args

    init:->

      unless @Config? then return c.l "no module Config"
      unless @i18n? then return c.l "no module i18n"
      unless @Controller? then @Controller = Controller

      @Config = JSON.parse @Config
      config = @Config
      @Controller = new @Controller
        i18n: @i18n
        Config: @Config

      # collection
      if @Config.collectionName
        App[@Config.collectionName] = new @Controller.Collection
        App[@Config.collectionName].model = @Controller.Model
        App[@Config.collectionName].url = @Config.url
        App[@Config.collectionName].fetch
          success:->
            App.ready config.moduleName
            App.vent.trigger config.moduleName+":collection:ready"
      else
        App.ready @Config.moduleName

      unless @disableRoutes
        # Routes from Controller
        routes = @Controller.routes || {}
        # Standard Routes
        routes[@Config.moduleName] = "init"
        routes[@Config.moduleName+'/list/'] = "list"
        routes[@Config.moduleName+'/calendar/'] = "calendar"
        routes[@Config.moduleName+'/graph/'] = "visuals"
        routes[@Config.moduleName+'/map/'] = "map"
        routes[@Config.moduleName+'/new/'] = "add"
        routes[@Config.modelName+'/:id'] = "details"
        Router.processAppRoutes @Controller, routes

      if config.settings
        App.vent.trigger 'SettingsModule:translate', @i18n

      if config.navigation
        App.vent.trigger 'CmsModule:addNavItem',
          navigation:config.navigation
          route: config.moduleName
        , @i18n
