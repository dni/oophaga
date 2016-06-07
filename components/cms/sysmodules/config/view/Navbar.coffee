define [
  'cs!App'
  'marionette'
  'tpl!../templates/nav-item.html'
  'tpl!../templates/navbar.html'
], (App, Marionette, ItemTemplate, Template) ->

  class NavItemView extends Marionette.ItemView
    template: ItemTemplate
    render:->
      data = @serializeData()
      html = Marionette.Renderer.render @template, data, @
      if @model.get "sub"
        $("#sysnav").append html
      else
        $("#mainnav").append html

  class Navbar extends Marionette.CompositeView
    template: Template
    childView: NavItemView
    collection: App.NavItems
    className: "container"

