$ = require "../src/jquery"
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
      $(html).find("h3").text().should.equal "test"

    it "should render a component hierarchy as HTML", ->
      c = new fixtures.List [
        {title: "test1", content: "hello world"}
        {title: "test2", content: "hello tests"}
      ]
      v = fixtures.ListView
        title: "Hello list"
        collection: c
      $html = $ View.renderComponentToString v
      $html.find("h2").text().should.equal "Hello list"
      $html.find("h3")[0].innerHTML.should.equal "test1"
      $html.find("h3")[1].innerHTML.should.equal "test2"
