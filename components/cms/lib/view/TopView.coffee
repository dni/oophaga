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
      newRoute:false
      search:false
      icon: 'plus'

  class TopView extends Marionette.ItemView
    template: Template
    initialize: (args)->
      @model = new TopModel args

    events:
      "click #showlist": "showList"
      "click #showvisuals": "showVisuals"
      "click #showcalendar": "showCalender"
      "click #showmap": "showMap"

    setActive:(el)->
      $el = $(el).parent()
      return if $el.hasClass("active")
      @$el.find("button.active").removeClass("active")
      $el.addClass "active"

    showList: (e)=>
      return unless @setActive(e.target)
      c.l "showList"

    showVisuals: (e)=>
      return unless @setActive(e.target)
      c.l "showV"

    showCalender: (e)=>
      return unless @setActive(e.target)
      c.l "showV"

    showMap: (e)=>
      return unless @setActive(e.target)
      c.l "showV"
