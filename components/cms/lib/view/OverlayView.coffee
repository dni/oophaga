define [
  'jquery'
  'cs!App'
  'cs!Oophaga'
  'marionette'
  'i18n!modules/cms/nls/language'
  'tpl!lib/templates/overlay.html'
], ($, App, Oophaga, Marionette, i18n, Template) ->
  class OverlayView extends Marionette.LayoutView
    className:"modal"
    template: Template
    templateHelpers: ->
      t: i18n

    regions:
      childRegion: '.modal-content'

    initialize:->
      @childRegion.on "show", ->
        $(".modal").modal "show"
      @childRegion.on "empty", ->
        $(".modal").modal "hide"

    show: (view)->
      @childRegion.show view

    events:
      "click .ok": "ok"
      "click .cancel": "cancel"

    ok:=>
      @childRegion.currentView?.ok?()
      @childRegion.empty()
      $(".modal").modal "hide"

    cancel:=>
      @childRegion.empty()
      $(".modal").modal "hide"
