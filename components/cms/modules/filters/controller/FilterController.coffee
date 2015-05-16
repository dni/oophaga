define [
  'cs!Oophaga'
],
(Oophaga) ->
  class FilterController extends Oophaga.Controller.Controller
    routes:
      "addFilter/:id": "addfili"

    addfili: (id)->
      debugger
