define [
  'marionette'
  'tpl!../templates/navbar.html'
  'cs!./NavigationView'
], (Marionette, Template, NavigationView) ->
  class LayoutView extends Marionette.LayoutView
    template: Template
    className: "container"
    initialize: (args)->
      @on "render", ->
        @$el.find("#subnav").append (new NavigationView collection: args.subnavitems, className: "dropdown-menu").render().el
        @$el.find("#navigation").prepend (new NavigationView collection: args.navitems, className: "nav navbar-nav").render().el


