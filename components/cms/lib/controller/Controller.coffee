define [
  'cs!App'
  'cs!Utils'
  'cs!Router'
  'marionette'
  'underscore'
  "cs!../model/Model"
  "cs!../model/Collection"
  "cs!../view/EmptyView"
  "cs!../view/TopView"
  "cs!../view/ListView"
  "cs!../view/DetailView"
  "cs!../view/GraphView"
  "cs!../view/CalendarView"
  "cs!../view/MapView"
], ( App, Utilities, Router, Marionette, _, Model, Collection, EmptyView, TopView, ListView, DetailView, GraphView, CalendarView, MapView) ->


  class Controller extends Marionette.Controller
    constructor: (args)->
      @[key] = arg for key, arg of args
      unless @Model? then @Model = Model
      unless @Collection? then @Collection = Collection
      unless @DetailView? then @DetailView = DetailView
      unless @ListView? then @ListView = ListView
      unless @GraphView? then @GraphView = GraphView
      unless @CalendarView? then @CalendarView = CalendarView
      unless @MapView? then @MapView = MapView
      unless @TopView? then @TopView = TopView
      unless @EmptyView? then @EmptyView = EmptyView

    defaultView: ->
      @renderTopView()
      action = @controls.get "activeView"
      @[action]()

    getCollection: ->
      unless @FilteredCollection?
        @FilteredCollection = Utilities.FilteredCollection App[@Config.collectionName]
        @FilteredCollection.filter @filterFunction
      @FilteredCollection

    filter: (filterId)->
      activeFilters = @controls.get "activeFilters"
      if !activeFilters.indexOf(filterId)
        i = activeFilters.indexOf filterId
        activeFilters.splice i, 1
      else
        activeFilters.push filterId
      @controls.set "activeFilters", activeFilters
      Router.navigate @Config.moduleName
      @FilteredCollection.filter @controls.filterFunction

    renderTopView:->
      @controls.set "filters", App.Filters.where relation: @Config.moduleName
      @controls.on "change", @filterCollection
      App.listTopRegion.show new @TopView
        navigation: @i18n.navigation
        moduleName: @Config.moduleName
        model: @controls

    newDetailView:(model)->
      @detailView = new @DetailView
        model: model
        Config: @Config
        i18n: @i18n

    getContentView:(model)->
      @newDetailView model

    createNewModel: (relation)->
      date = new Date
      model = new @Model
      model.urlRoot = @Config.dbTable
      model.collectionName = @Config.collectionName
      model.set
        relation: relation
        published: false
        date: date
        crdate: date
        user: App.User.get "_id"
        cruser: App.User.get "_id"
        fields: @Config.model
        fieldorder: @Config.fields
        name: @Config.modelName
      return model

    edit: (id) ->
      @renderTopView() unless App.listTopRegion.currentView?
      model = App[@Config.collectionName].findWhere _id: id
      if model
        view = @getContentView model
      else
        view = new @EmptyView message: @i18n.emptyMessage
      view.i18n = @i18n
      App.overlayRegion.currentView.childRegion.show view

    add: (relation)->
      model = @createNewModel relation
      App.overlayRegion.currentView.childRegion.show @getContentView model

    graph:->
      @controls.set "activeView", "graph"
      @renderTopView() unless App.listTopRegion.currentView?
      App.contentRegion.show new @GraphView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    calendar:->
      @controls.set "activeView", "calendar"
      @renderTopView() unless App.listTopRegion.currentView?
      App.contentRegion.show new @CalendarView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    map:->
      @controls.set "activeView", "map"
      @renderTopView() unless App.listTopRegion.currentView?
      App.contentRegion.show new @MapView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    init: ->
      App.detailRegion.empty()
      @list()


    list: ->
      @controls.set "activeView", "list"
      @renderTopView() unless App.listTopRegion.currentView?
      App.contentRegion.show new @ListView
        config: @Config
        columns: @Config.columns
        i18n: @i18n
        collection: @getCollection()
