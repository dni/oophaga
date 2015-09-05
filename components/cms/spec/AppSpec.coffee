define [
  'chai'
  'cs!App'
], (chai, App)->
  except = chai.expect

  describe "App", ->
    it "should load app", ->
      expect(App).to.be.truthy
      expect(App.modules).to.be.an "object"

