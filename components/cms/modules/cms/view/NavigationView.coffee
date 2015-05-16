define [
  'jquery'
  'marionette'
  'tpl!../templates/nav-item.html'
],
($, Marionette, Template) ->

  class NavigationItemView extends Marionette.ItemView
    template: Template
    onRender:->
      @$el = @$el.children()
      @$el.unwrap()
      @setElement @$el

  class NavigationView extends Marionette.CollectionView
    childView: NavigationItemView
    tagName: "ul"
    events:
      "click a": "clicked"
