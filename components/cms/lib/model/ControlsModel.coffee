define [
  'cs!App'
  'backbone'
], (App, Backbone) ->
  class Model extends Backbone.Model
    defaults:
      views:
        list: "list"
        graph: "stats"
        map: "map-marker"
        calendar: "calendar"
      activeView: "list"
      filters: {}
      activeFilters: []
      groups: true
      activeGroups: []
      create:true
      filter:true
      group:true
      sort:true


    filterFunction: (model)=>
      condition = true
      @get("activeFilters").forEach (filterId)->
        filter = App.Filters.findWhere _id: filterId
        if model.getValue(filter.getValue("field")) isnt filter.getValue("input")
          condition = false
      condition
