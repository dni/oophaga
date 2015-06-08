define [
  'cs!Router'
  'jquery'
  'marionette'
  'tpl!../templates/top.html'
],
(Router, $, Marionette, Template) ->

  class TopView extends Marionette.ItemView
    template: Template
    className: "container"
    events:
      "click .view": "setActive"
      "click .filter": "filter"
      "click .import": "import"
      "click .remove": "remove"
      "click .export": "export"

    filter: (e)->
      $(e.currentTarget).parent().toggleClass "active"

    export:-> @trigger "export"
    remove: -> @trigger "removeSelected"

    setActive:(e)->
      @$el.find(".active").removeClass "active"
      $(e.currentTarget).addClass "active"

