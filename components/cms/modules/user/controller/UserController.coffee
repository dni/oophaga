define [
  'cs!Oophaga'
], (Oophaga) ->
  class UserController extends Oophaga.Controller.Controller

    routes:
      "General": "logout"

    logout: ->
      if confirm @i18n.confirmLogout then window.location = window.location.origin + '/logout'
