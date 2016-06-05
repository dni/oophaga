define [
  'cs!lib/App'
  'marionette'
  'tpl!../templates/login.html'
  'cs!lib/utilities/cookie'
  'jquery'
  'jquery.form'
], (App, Marionette, Template, cookie, $) ->
  class LoginView extends Marionette.LayoutView
    template: Template
    onRender: ->
      @$el.ajaxForm
        success: (data)->
          if data.success
            cookie.write "token", data.token
            App.initApp()
          else
            alert "error login"


