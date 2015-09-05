webdriverio = require('webdriverio')
options = desiredCapabilities: browserName: 'firefox'
client = webdriverio.remote(options)

App = require "../app"

describe "UI - Usertests", ->
  server = {}
  apiUrl = "http://localhost:1666"

  before (done)->
    server = App
      port: 1666
      dbname: "oophaga-test"
      adminroute: "/"
    , ->
      client
         .init()
         .url(apiUrl)
         .call done

  after (done)->
    client.end()
    server.close done

  it "login should work", (done)->
    client
      .setValue "#username", "admin"
      .setValue "#password", "password"
      .submitForm "#loginform"
      .call done

  it "specrunner shouldnt fail", (done)->
    client
      .url("#{apiUrl}/specrunner.html")
      .pause 3000
      .call done

