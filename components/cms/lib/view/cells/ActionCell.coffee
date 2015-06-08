define [
  'backgrid'
  'cs!Router'
], ( Backgrid, Router ) ->
  class DeleteCell extends Backgrid.Cell
    template: _.template """
      <button class='showrow btn btn-default btn-xs'><span class='glyphicon glyphicon-eye-open'></span></button>
      <button class='edit btn btn-default btn-xs'><span class='glyphicon glyphicon-edit'></span></button>
      <button class='delete btn btn-default btn-xs'><span class='glyphicon glyphicon-trash'></span></button>
    """
    events:
      "click .delete": "deleteRow"
      "click .edit": "editRow"
      "click .showrow": "showRow"
    deleteRow: (e)->
      e.preventDefault()
      @model.destroy()
    editRow: (e)->
      e.preventDefault()
      Router.navigate @model.getEditHref(), trigger:true
    showRow: (e)->
      e.preventDefault()
      Router.navigate @model.getHref(), trigger:true
    render: ->
      this.$el.html(this.template())
      this.delegateEvents()
