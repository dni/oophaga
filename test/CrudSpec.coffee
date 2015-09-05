App = require "../app"
crud = require "../components/cms/lib/utilities/crud"
moduleConfig = require "./module-configuration.json"
expect = require("chai").expect
server = {}

describe "Crud Utility", ->

  before (done)->
    server = App
      port: 2010
      dbname: "oophaga-test"
      adminroute: "/"
    , done

  after (done)->
    server.close done

  it "it should setup all routes for module", ->
    crud moduleConfig

