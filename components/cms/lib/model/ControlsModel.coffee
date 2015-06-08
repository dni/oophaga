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
      groups: false
      activeGroups: []
      create:true
      filter:false
      group:false
      deleteAble:true
      importExport: false


    filterFunction: (model)=>
      condition = true
      @get("activeFilters").forEach (filterId)->
        filter = App.Filters.findWhere _id: filterId
        if model.getValue(filter.getValue("field")) isnt filter.getValue("input")
          condition = false
      condition
