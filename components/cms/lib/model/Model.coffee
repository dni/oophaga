define [
  'cs!App'
  'backbone'
  'underscore'
], (App, Backbone, _) ->
  class Model extends Backbone.Model
    idAttribute: "_id"

    defaults: fields: {}

    initialize: ->
      @on "change", ->
        @changes.push @previousAttributes()

    getHref: -> "##{@get('name')}/#{@get('_id')}"

    getCalenderEvent: ->
      title: @getValue "title"
      url: @getHref()
      start: @get "crdate"

    getLocation:->
      lat: @get 'lat'
      lng: @get 'lng'

    setLocation:(pos)->
      @set 'lat', pos[0]
      @set 'lng', pos[1]

    setValue: (fieldname, val)->
      fields = @get "fields"
      if _.isObject fieldname
        for key, value of fieldname
          throw new Error("Field doesnt exist", key) unless fields[key]
          fields[key].value = value
      else
        throw new Error("Field doesnt exist", fieldname) unless fields[fieldname]
        fields[fieldname].value = val
      @set "fields", fields

    getValue: (fieldname)->
      fields = @get "fields"
      # throw new Error("Field doesnt exist", fieldname) unless fields[fieldname]
      return fields[fieldname]?.value

    getCollection: (fieldname, collectionField)->
      fields = @get "fields"
      field = fields[fieldname]
      if field
        collectionName = fields[fieldname].collection
        coll = App[collectionName].findWhere "_id":fields[fieldname].value
        coll.getValue collectionField

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
