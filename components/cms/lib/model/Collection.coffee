define [
  "backbone"
  "cs!utilities/cookie"
], (Backbone, cookie) ->

  _sync = Backbone.sync
  Backbone.sync = (method, model, options) ->
    options.beforeSend = (xhr) ->
      xhr.setRequestHeader 'Authorization', cookie.read "token"
    _sync.call @, method, model, options

  class Collection extends Backbone.Collection
    getCalendarEvents: ->
      return @calendarevents if @calendarevents
      @calendarevents = @map (model)-> model.getCalenderEvent()
