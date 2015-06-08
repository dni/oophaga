define [
  'cs!App'
  'backbone'
  'underscore'
], (App, Backbone, _) ->
  class Model extends Backbone.Model
    idAttribute: "_id"

    initialize: ->
      @on "change", ->
        @changes.push @previousAttributes()

    getHref: -> "##{@moduleName}/show/#{@get('_id')}"
    getEditHref: -> "##{@moduleName}/edit/#{@get('_id')}"

    getCalenderEvent: ->
      title: @get "title"
      url: @getHref()
      start: @get "crdate"

    getLocation:->
      lat: @get 'lat'
      lng: @get 'lng'

    setLocation:(pos)->
      @set 'lat', pos[0]
      @set 'lng', pos[1]

    getCollection: (fieldname, collectionField)->
      fields = @get "fields"
      field = fields[fieldname]
      if field
        collectionName = fields[fieldname].collection
        coll = App[collectionName].findWhere "_id":fields[fieldname].value
        coll.get collectionField

    togglePublished: ->
      @set "published", not @get "published"

    changes: []
    undone: []

    undo: ->
      return unless change = @changes.pop()
      @undone.push @toJSON()
      @set change

    redo: ->
      return unless undo = @undone.pop()
      @set undo
