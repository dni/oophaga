define [
  'cs!lib/controller/Controller'
], (Controller) ->
  class UserController extends Controller

    routes:
      "General": "logout"

    logout: ->
      if confirm @i18n.confirmLogout then window.location = window.location.origin + '/logout'
