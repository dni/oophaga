define [
  'cs!App'
  'cs!Oophaga'
  'text!modules/example/configuration.json'
], (App, Oophaga,Config)->

  describe "Oophaga", ->
    it "should load", ->
      expect(Oophaga).toBeTruthy()

    describe "Utils", ->
      it "should load",->
        expect(Oophaga.Utils).toBeTruthy()

      describe "Viewhelpers",->
        it "should load",->
          expect(Oophaga.Utils.Viewhelpers).toBeTruthy()

    describe "Module", ->
      module = {}
      beforeEach ->
        module = new Oophaga.Module
          Config: Config
          i18n:
            "attributes":
              "lol": "LOL"
        module.init()

      it "should init",->
        expect(module).toBeTruthy()
      it "should have some objects", ->
        expect(Object.keys(module).length).toBeTruthy()
      it "Collection should be in App", ->
        expect(App.Examples).toBeTruthy()

    describe "Controller", ->
      it "should load",->
        expect(Oophaga.Controller).toBeTruthy()
      describe "Simple Controller", ->
        it "should load",->
          expect(Oophaga.Controller.Controller).toBeTruthy()
        it "should initiate",->
          expect(new Oophaga.Controller.Controller).toBeTruthy()

    describe "View", ->
      it "should load",->
        expect(Oophaga.View).toBeTruthy()
      describe "MapView", ->
        it "MapView should exist", ->
          expect(Oophaga.View.MapView).toBeTruthy()

    describe "Model", ->
      it "should load", ->
        expect(Oophaga.Model).toBeTruthy()
      it "should create new Model", ->
        model = new Oophaga.Model
        expect(model).toBeTruthy()

      it "setValue of non existing field should throw", ->
        model = new Oophaga.Model
        expect ->
          model.setValue "lol", "lol"
        .toThrow new Error "Field doesnt exist"

      it "getValue of non existing field should throw", ->
        model = new Oophaga.Model
        expect ->
          model.getValue "lol"
        .toThrow new Error "Field doesnt exist"

    describe "Collection", ->
      it "should load",->
        expect(Oophaga.Collection).toBeTruthy()
