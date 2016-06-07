define [
  'cs!App'
  'cs!Router'
  'cs!utilities/Utilities'
  'cs!lib/model/Model'
  'jquery'
  'underscore'
  'marionette'
  'tpl!../templates/browse.html'
  'tpl!../templates/browse-item.html'
], (App, Router, Utilities, Model, $, _, Marionette, Template, ItemTemplate) ->

  class BrowseItemView extends Marionette.ItemView
    template: ItemTemplate
    ui:
      item: '.browse-item'
    events:
      "click @ui.item": 'toggleSelect'

    toggleSelect: (e)->
      selected = @model.get("selected") || false
      @model.set "selected", !selected
      @ui.item.toggleClass? 'selected'


  class BrowseView extends Marionette.CompositeView
    template: Template
    childView: BrowseItemView
    childViewContainer: "#browse-body"
    initialize: (args)->
      @model = args.model
      @multiple = args.multiple
      @fieldrelation = args.fieldrelation
      @collection = Utilities.FilteredCollection App.Files
      @collection.filter (file) -> !file.get("parent")?
      @collection.forEach (model) => model.set "multiple", @multiple
      if !@multiple then  @listenTo @collection, 'change', App.view.overlayRegion.currentView.ok

    events:
      "change #upload": "uploadFile"
      "click #ok": "ok"

    uploadFile: ->
      @$el.find("#uploadFile").ajaxForm (response) -> true
      @$el.find("#uploadFile").submit()

    ok: ->
      @collection.forEach (file)=>
        return unless file.get "selected"
        file.set("selected", false)
        newfile = new Model
        newfile.urlRoot = @Config.urlRoot
        newfile.collectionName = @Config.collectionName
        newfile.set _.clone file.attributes
        delete newfile.attributes._id
        newfile.set
          'parent': file.get "_id"
          'relation': @model.get "_id"
          'fieldrelation': @fieldrelation
        App.Files.create newfile,
          wait:true
          success: =>
            Router.navigate @model.getEditHref(), trigger:true
