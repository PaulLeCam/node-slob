cheerio = require "cheerio"
{Model, View, Collection} = require "../src/framework"
fixtures = require "./fixtures"

describe "framework", ->

  describe "model", ->

    it "`toJSON()` method should include `id` value of model", ->
      class TestModel extends Model
        idAttribute: "_id"
      m = new TestModel _id: "test"
      json = m.toJSON()
      json.should.have.property("id").equal "test"

    it "should have the `emit` alias for `trigger`", (done) ->
      m = new Model
      m.on "ev", -> done()
      m.emit "ev"

  describe "collection", ->

    it "should have the `emit` alias for `trigger`", (done) ->
      m = new Collection
      m.on "ev", -> done()
      m.emit "ev"

  describe "view", ->

    it "should render a single component as HTML", ->
      m = new fixtures.Item
        title: "test"
        content: "hello world"
      v = fixtures.ItemView model: m
      html = View.renderComponentToString v
      $ = cheerio.load html
      $("h3").text().should.equal "test"

    it "should render a component hierarchy as HTML", ->
      c = new fixtures.List [
        {title: "test1", content: "hello world"}
        {title: "test2", content: "hello tests"}
      ]
      v = fixtures.ListView
        title: "Hello list"
        collection: c
      $ = cheerio.load View.renderComponentToString v
      $("h2").text().should.equal "Hello list"
      $($("h3")[0]).text().should.equal "test1"
      $($("h3")[1]).text().should.equal "test2"
