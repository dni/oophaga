define [
  'cs!App'
  'jquery'
  'marionette'
  'tpl!../templates/list-item.html'
  'tpl!../templates/list.html'
  'cs!Utils'
  'cs!Router'
], (App, $, Marionette, Template, TemplateList, Utils, Router) ->
  columns=[]
  class ListItemView extends Marionette.ItemView
    tagName: "tr"
    template: Template
    templateHelpers:->
      vhs: _.extend Utils.Viewhelpers, config: @options.config
      columns: columns
    events:
      "click .ok": "selectItem"
      "click .show": "showItem"
      "click .edit": "editItem"
      "click .remove": "removeItem"
    editItem: ->
      Router.navigate @model.getEditHref(), trigger: true
    showItem: ->
      Router.navigate @model.getHref(), trigger: true
    selectItem:->
      @$el.toggleClass 'info'
    removeItem:->
      @model.destroy()

  class ListView extends Marionette.CompositeView
    childView: ListItemView
    template: TemplateList
    events:
      "click th": "clickSort"
    childViewContainer: 'tbody'
    childViewOptions: ->
      config: @options.config
    childEvents:
      newclick: ->
        @children.forEach (child)->
          child.$el.removeClass('success')
    clickSort:(e)->
      return
      target = $(e.target)
      @collection.comparator = (item)->
        fields = item.get "fields"
        field = fields[target.attr("class")]
        return c.l "field doesnt exist" unless field
        if field.collection
          App[field.collection].findBy _id: field.value, (model)->
            model.get("title")
        else
          -field.get target.attr("class")
        -item.get(target.attr("class"))
      @collection.sort()

    initialize:->
      columns = @columns or @options.columns
      if @relatedView
        @collection = Utils.FilteredCollection App[@collectionName]
        @collection.filter (model)=> model.get(@fieldName) is @model.get("_id")
        @collection.comparator = (model)-> -(new Date model.get("date")).getTime()
        @collection.sort()

    templateHelpers:->
      i18n: @options.i18n or @i18n
      columns: columns

  return ListView
