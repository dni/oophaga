define ['jquery', "cs!App"], ($, App)->

  jasmine.DEFAULT_TIMEOUT_INTERVAL = 9999
  describe "requirejs", ->
    it "require jsshould be available", ->
      expect($).toBeTruthy()


  describe "App", ->
    it "should load App", ->
      expect(App).toBeTruthy()

