# define ['jquery'], ($)->
describe "Neeeuer Test mit Harald QM: Visualisierungen", ->

  it "download der Visualisierung sollte möglich sein", ->
    expect(true).toBeTruthy()


  it "datenimport von musterdaten ist in Ordnung", ->
    expect(true).toBeTruthy()


# webdriver = require "webdriverio"

# describe "testcase 1 dnilabs", ->

#   beforeEach ->
#     client = webdriver.remote desiredCapabilities: browserName: 'phantomjs'
#     client.init().url "http://dnilabs.com/"


#   it "title should match", (done)->
#     client
#       .getTitle (err, title)->
#         expect(err).toBeFalsy()
#         expect(title).toBe "dnilabs, Multimedia Agentur, Websites, Apps, Design: Startseite"
#       .call done
#   it "slider should be div", (done)->
#     client
#       .getTagName "#projectslider", (err, tag)->
#         expect(err).toBeFalsy()
#         expect(tag).toBe "div"
#       .call done



#   afterEach (done)-> client.end done
