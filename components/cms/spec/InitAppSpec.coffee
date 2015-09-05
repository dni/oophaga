define [
  'chai'
  'cs!App'
], (chai, App)->
  except = chai.expect


  describe "Init App", ->
    it "should initialize all modules and fire ready event", (done)->
      App.init()
      App.vent.on "ready", done
