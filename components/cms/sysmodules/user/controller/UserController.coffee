define [
  'cs!lib/controller/Controller'
  'cs!lib/utilities/cookie'
], (Controller, cookie) ->
  class UserController extends Controller

    routes:
      "logout": "logout"

    logout: ->
      if confirm @i18n.confirmLogout
        cookie.delete "token"
        window.location = window.location.origin
