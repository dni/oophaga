define [
  'cs!App'
  'cs!Router'
  'marionette'
  'underscore'
  'tpl!lib/templates/show.html'
  'cs!sysmodules/file/view/RelatedFileView'
  'cs!lib/utilities/Viewhelpers'
], (App, Router, Marionette, _, Template, RelatedFileView, vhs) ->

  class ShowView extends Marionette.LayoutView
    template: Template
    regions:
      relatedRegion: "#relations"

    initialize:(args)->
      @model = args.model
      @relatedView = args.relatedView
      @on "render", @afterRender, @

    templateHelpers: ->
      vhs: _.extend vhs, Config: @options.Config, i18n: @options.i18n
