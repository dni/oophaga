define [
  'cs!Router'
  'jquery'
  'marionette'
  'tpl!../templates/top.html'
],
(Router, $, Marionette, Template) ->

  class TopView extends Marionette.ItemView
    template: Template

    templateHelpers: =>
      i18n: @options.i18n

    className: "container"
    events:
      "click .view": "setActive"
      "click .filter": "filter"
      "change .import": "import"
      "click .remove": "remove"
      "click .export": "export"

    filter: (e)->
      $(e.currentTarget).parent().toggleClass "active"

    import:=>
      @$el.find(".import").ajaxForm (response) -> true
      @$el.find(".import").submit()

    export:-> @trigger "export"
    remove: -> @trigger "removeSelected"

    setActive:(e)->
      @$el.find(".active").removeClass "active"
      $(e.currentTarget).addClass "active"

