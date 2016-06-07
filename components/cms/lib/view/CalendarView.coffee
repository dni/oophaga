define [
  'cs!App'
  'tpl!../templates/cal.html'
  'jquery'
  'fullcalendar'
  'marionette'
  'cs!Router'
], (App, Template, $, fullCalendar, Marionette, Router) ->

  class CalendarView extends Marionette.CompositeView
    className: "container"
    render: ->
      setTimeout => # wait i little bit ;) for calendar else it wont render correctly
        @$el.fullCalendar
          events: @collection.getCalendarEvents()
          header:
            left: 'prev,next today'
            center: 'title'
            right: 'month,basicWeek,basicDay'
      , 50

