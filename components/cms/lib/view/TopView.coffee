define [
  'backbone'
  'jquery'
  'marionette'
  'tpl!../templates/top.html'
],
(Backbone, $, Marionette, Template) ->

  class TopView extends Marionette.ItemView
    template: Template
    className: "container"
    events:
      "click .view": "setActive"
      "click .filter": "filter"

    filter: (e)->
      $(e.currentTarget).parent().toggleClass "active"

    setActive:(e)->
      @$el.find(".active").removeClass "active"
      $(e.currentTarget).addClass "active"

