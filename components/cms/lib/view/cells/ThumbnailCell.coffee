define [
  'backgrid'
], ( Backgrid ) ->
  class ThumbnailCell extends Backgrid.Cell
    render: ->
      this.$el.html """
        <img style="width:150px!important" src="/public/files/#{@model.get('thumbnail')}" alt="">
      """
      this.delegateEvents()
