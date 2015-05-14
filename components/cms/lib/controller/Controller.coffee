define [
  'cs!App'
  'cs!Utils'
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
], ( App, Utilities, Marionette, _, Model, Collection, EmptyView, TopView, ListView, DetailView, GraphView, CalendarView, MapView) ->

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

    getCollection: ->
      unless @FilteredCollection?
        @FilteredCollection = Utilities.FilteredCollection App[@Config.collectionName]
      @FilteredCollection.filter @filterFunction
      @FilteredCollection

    newDetailView:(model)->
      @detailView = new @DetailView
        model: model
        Config: @Config
        i18n: @i18n

    getContentView:(model)->
      model = @createNewModel() unless model?
      @newDetailView model

    createNewModel: ->
      date = new Date
      model = new @Model
      model.urlRoot = @Config.dbTable
      model.collectionName = @Config.collectionName
      model.set
        published: false
        date: date
        crdate: date
        user: App.User.get "_id"
        cruser: App.User.get "_id"
        fields: @Config.model
        fieldorder: @Config.fields
        name: @Config.modelName
      return model

    details: (id) ->
      @renderTopView unless App.listTopRegion.currentView?
      model = App[@Config.collectionName].findWhere _id: id
      if model
        view = @getContentView model
      else
        view = new @EmptyView message: @i18n.emptyMessage
      view.i18n = @i18n
      App.overlayRegion.currentView.childRegion.show view

    add: ->
      App.overlayRegion.currentView.childRegion.show @getContentView()

    visuals:->
      App.contentRegion.show new @GraphView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    calendar:->
      App.contentRegion.show new @CalendarView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    map:->
      App.contentRegion.show new @MapView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    init: ->
      App.detailRegion.empty()
      @list()

    renderTopView:->
      App.listTopRegion.show new @TopView
        navigation: @i18n.navigation
        model: @Config.model?
        newModel: @Config.model?
        moduleName: @Config.moduleName
    list: ->
      @renderTopView()
      App.contentRegion.show new @ListView
        config: @Config
        columns: @Config.columns
        i18n: @i18n
        collection: @getCollection()
