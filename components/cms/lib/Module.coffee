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
      nsp = config.get "namespace"

      # set default module controller class
      @Controller = Controller unless @Controller?

      @Config = config
      require ["i18n!nls/#{nsp}"], (i18n)=>

        @Controller = new @Controller
          i18n: i18n
          Config: @Config
          controls: new ControlsModel

        if @Config.get "controls"
          @Controller.controls.set @Config.get "controls"
          @Controller.controls.set "namespace", nsp
          @Controller.controls.set "label", i18n[navigation]

        # Routes from Controller
        routes = @Controller.routes || {}

        # Standard Routes
        routes[nsp] = "defaultView"

        if @Controller.controls.get "create"
          routes["#{nsp}/new/"] = "add"
          routes["#{nsp}/new/:relation"] = "add"

        routes["#{nsp}/filter/:filterId"] = "filter" if @Controller.controls.get "filter"
        routes["#{nsp}/edit/:id"] = "edit"
        routes["#{nsp}/show/:id"] = "show"
        routes["#{nsp}/action/:action"] = "action"

        views = @Controller.controls.get "views"
        Object.keys(views).forEach (key)=>
          href = "#{nsp}/#{key}/"
          routes[href] = key

        @Controller.controls.set
          namespace: nsp

        Router.processAppRoutes @Controller, routes


        if @Config.get "navigation"
          navigation = @Config.get "navigation"
          navigation.namespace = nsp
          navigation.label = i18n.navigation
          App.NavItems.add navigation

        # collection
        cname = @Config.get "collectionName"
        if cname
          App[cname] = new @Controller.Collection
          App[cname].model = @Controller.Model.extend namespace: nsp
          App[cname].url = @Config.get "url"
          App[cname].fetch
            success:->
              App.ready()
        else
          App.ready()
