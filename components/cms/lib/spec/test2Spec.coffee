define ['jquery', "cs!App"], ($, App)->

  describe "requirejs", ->
    it "require jsshould be available", ->
      expect($).toBeTruthy()


  describe "App", ->
    it "should load App", ->
      expect(App).toBeTruthy()

