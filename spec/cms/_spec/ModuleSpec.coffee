define ['cs!lib/model/Model'], (OverlayView)->
  console.log Utils, Controller
  describe "oophaga module", ->
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 9999
    it "create new module", (done)->
      expect(Oophaga).toBeTruthy()
      done()
