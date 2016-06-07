define [
  'cs!App'
  'cs!Router'
  'marionette'
  'tpl!lib/templates/show.html'
  'cs!sysmodules/file/view/RelatedFileView'
], (App, Router, Marionette, Template, RelatedFileView) ->

  class ShowView extends Marionette.LayoutView
    template: Template
    regions:
      relatedRegion: "#relations"

    initialize:(args)->
      @model = args.model
      @relatedView = args.relatedView
      @on "render", @afterRender, @

    templateHelpers: ->
