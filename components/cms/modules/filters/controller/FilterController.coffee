define [
  'cs!lib/controller/Controller'
],
(Controller) ->
  class FilterController extends Controller
    routes:
      "addFilter/:id": "addfili"

    addfili: (id)->
      debugger
