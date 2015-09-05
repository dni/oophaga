App = require "../app"
Schema = require "../components/cms/lib/model/Schema"
metaAttributes = require "../components/cms/lib/utilities/meta-attributes.json"
attributes = Object.keys metaAttributes
expect = require("chai").expect
server = {}

describe "Schema", ->

  before (done)->
    server = App
      port: 2010
      dbname: "oophaga-test"
      adminroute: "/"
    , done

  after (done)->
    server.close done

  it "get uninitialized Schema with string should throw Error", ->
    TestSchema = -> Schema "testss"
    expect(TestSchema).to.throw Error

  it "should create new Schema with all metaattributes", ->
    TestSchema = Schema
      dbTable: "testss"
      model:
        title:
          required: true
          db: "String"
          type: "text"
    expect(TestSchema).to.not.be.undefined
    attributes.push "title"
    attributes.forEach (attribute)->
      expect(TestSchema.schema.paths[attribute]).to.not.be.undefined

  it "get schema with string should now return the Schema", ->
    TestSchema = Schema "testss"
    expect(TestSchema).to.be.defined

  it "should return the UserSchema", ->
    expect(Schema("users")).to.be.defined

