define [
  'jquery'
  'cs!App'
  'marionette'
  'i18n!modules/cms/nls/language'
  'tpl!lib/templates/overlay.html'
], ($, App, Marionette, i18n, Template) ->
  class OverlayView extends Marionette.LayoutView
    className:"modal"
    template: Template
    templateHelpers: ->
      t: i18n

    regions:
      childRegion: '.modal-content'

    initialize:->
      timeout = ""
      @$el.on "hidden.bs.modal", =>
        @childRegion.empty()
      @childRegion.on "empty", ->
        $(".modal").modal "hide"
      @childRegion.on "show", ->
        clearTimeout timeout
        $(".modal").modal "show"

    show: (view)->
      @childRegion.show view
