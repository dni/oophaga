define [
  'backbone'
  'jquery'
  'marionette'
  'tpl!../templates/top.html'
],
(Backbone, $, Marionette, Template) ->

  class TopModel extends Backbone.Model
    defaults:
      navigation: 'Navigation Title'
      newModel:false
      model:false
      newRoute:false
      search:false
      icon: 'plus'

  class TopView extends Marionette.ItemView
    template: Template
    initialize: (args)->
      @model = new TopModel args
    events:
      "click .view": "setActive"
    setActive:(e)->
      $el = $(e.target).parent()
      return if $el.hasClass("active")
      @$el.find(".active").removeClass("active")
      $el.addClass "active"
