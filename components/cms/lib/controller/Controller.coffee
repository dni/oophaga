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
  "cs!../view/EditView"
  "cs!../view/ShowView"
  "cs!../view/GraphView"
  "cs!../view/CalendarView"
  "cs!../view/MapView"
], ( App, Utilities, Router, Marionette, _, Model, Collection, EmptyView, TopView, ListView, EditView, ShowView, GraphView, CalendarView, MapView) ->


  class Controller extends Marionette.Controller
    constructor: (args)->
      @[key] = arg for key, arg of args
      unless @Model? then @Model = Model
      unless @Collection? then @Collection = Collection
      unless @EditView? then @EditView = EditView
      unless @ShowView? then @ShowView = ShowView
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
      @topview = new @TopView
        navigation: @i18n.navigation
        moduleName: @Config.moduleName
        model: @controls
      @topview.on "export", @exportSelected, @
      # @topview.on "removeSelected", @removeSelected, @
      App.view.listTopRegion.show @topview

    newEditView:(model)->
      @detailView = new @EditView
        model: model
        Config: @Config
        i18n: @i18n

    getContentView:(model)->
      @newEditView model

    createNewModel: (relation)->
      fields= {}
      date = new Date
      model = new @Model
      model.urlRoot = @Config.dbTable
      model.collectionName = @Config.collectionName
      model.moduleName = @Config.moduleName
      Object.keys(@Config.model).forEach (key)=>
        fields[key] = @Config.model[key].default or ""
      model.set
        relation: relation
        published: false
        date: date
        crdate: date
        fieldorder: @Config.fields
      model.set fields
      return model

    edit: (id) ->
      @renderTopView() unless App.view.listTopRegion.currentView?
      model = App[@Config.collectionName].findWhere _id: id
      if model
        view = @getContentView model
      else
        view = new @EmptyView message: @i18n.emptyMessage
      view.i18n = @i18n
      App.view.overlayRegion.currentView.childRegion.show view

    show: (id) ->
      @renderTopView() unless App.view.listTopRegion.currentView?
      model = App[@Config.collectionName].findWhere _id: id
      if model
        view = new @ShowView
          model: model
          Config: @Config
          i18n: @i18n
      else
        view = new @EmptyView message: @i18n.emptyMessage
      view.i18n = @i18n
      App.view.overlayRegion.currentView.childRegion.show view

    add: (relation)->
      model = @createNewModel relation
      App.view.overlayRegion.currentView.childRegion.show @getContentView model

    graph:->
      @controls.set "activeView", "graph"
      @renderTopView() unless App.view.listTopRegion.currentView?
      App.view.contentRegion.show new @GraphView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    calendar:->
      @controls.set "activeView", "calendar"
      @renderTopView() unless App.view.listTopRegion.currentView?
      App.view.contentRegion.show new @CalendarView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    map:->
      @controls.set "activeView", "map"
      @renderTopView() unless App.view.listTopRegion.currentView?
      App.view.contentRegion.show new @MapView
        config: @Config
        i18n: @i18n
        className: "container"
        collection: @getCollection()

    init: ->
      App.view.detailRegion.empty()
      @list()

    removeSelected: (e)->
      # @grid.getSelectedModels().forEach (model)->
      #   model.destroy()
    exportSelected: ->
      # c.l "export", @grid.getSelectedModels()

    list: ->
      @controls.set "activeView", "list"
      @renderTopView() unless App.view.listTopRegion.currentView?
      collection = @getCollection()
      App.view.contentRegion.show new @ListView
        collection: collection
        columns: @Config.columns
        i18n: @i18n
      # @grid = new Backgrid.Grid
      #   collection: collection
      #   columns: @getColumns()
      # App.contentRegion.show @grid
      # filter = new Backgrid.Extension.ClientSideFilter
      #   collection: collection
      #   fields: ['title']

      # # add backgrid filter
      # App.contentRegion.currentView.$el.before filter.render().el
