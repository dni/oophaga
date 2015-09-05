define [
  'chai'
  'cs!lib/App'
  'cs!lib/Module'
], (chai, App, Module)->
  except = chai.expect

  describe "Module", ->
    module = {}

    it "should load module", ->
      expect(Module).to.be.truthy

    it "create a new module without config should throw an error", ->
      module = new Module
      expect(module.init).to.be.throw Error

    it "create a new module and check initializsation", ->
      module = new Module
        i18n:
          test: "test"
        Config:
          moduleName: "TestModule"
          test: true

    it "should get all arguments",->
      expect(module.Config.test).to.be.true

    it "should not throw an error on init function",->
      expect(module.init).to.not.throw Error

    it "should have a controller", ->
      expect(module.Controller).to.be.an "object"

    it "controller should have a list view", ->
      expect(module.Controller.ListView).to.exist

