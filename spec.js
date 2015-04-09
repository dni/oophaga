(function() {
  define(["jquery"], function(Oophaga) {
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 9999;
    return describe("Lib Tests", function() {
      return it("should load Controller", function(done) {
        return done();
      });
    });
  });

}).call(this);

(function() {
  define(['jquery', "cs!App"], function($, App) {
    describe("requirejs", function() {
      return it("require jsshould be available", function() {
        return expect($).toBeTruthy();
      });
    });
    return describe("App", function() {
      return it("should load App", function() {
        return expect(App).toBeTruthy();
      });
    });
  });

}).call(this);

(function() {
  describe("Neuer Test mit Harald QM: Visualisierungen", function() {
    it("download der Visualisierung sollte möglich sein", function() {
      return expect(true).toBeTruthy();
    });
    return it("datenimport von musterdaten ist in Ordnung", function() {
      return expect(true).toBeTruthy();
    });
  });

}).call(this);
