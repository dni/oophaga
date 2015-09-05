App = require "../app"
expect = require("chai").expect
request = require "supertest"
server = {}

describe "REST API Tests", ->

  before (done) ->
    server = App
      port: 2010
      dbname: "oophaga-test"
      adminroute: "/"
    , done

  after (done)->
    server.close done

  it "should test", (done)->
    done()

