define [
  'cs!App'
  'tpl!../templates/cal.html'
  'jquery'
  'fullcalendar'
  'marionette'
  'cs!Utils'
  'cs!Router'
], (App, Template, $, fullCalendar, Marionette, Utils, Router) ->

  class CalendarView extends Marionette.CompositeView
    className: "container"
    render: ->
      setTimeout => # wait i little bit ;) for calendar else it wont render correctly
        @$el.fullCalendar events: @collection.getCalendarEvents()
      , 50

