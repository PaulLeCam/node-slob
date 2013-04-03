$ = require "jquery"
{mvc, template} = require "../src/framework"
fixtures = require "./fixtures"

describe "framework", ->

  describe "template", ->

    it "should register the `safe` helper", ->

      tmpl = template.compile "<div>{{safe content}}</div>"
      content = "<a href='#'>link</a>"
      res = tmpl {content}
      res.should.equal "<div><a href='#'>link</a></div>"

  describe "model", ->

    it "`toJSON()` method should include `id` value of model", ->
      class Model extends mvc.Model
        idAttribute: "_id"
      m = new Model _id: "test"
      json = m.toJSON()
      json.should.have.property("id").equal "test"

    it "should have the `emit` alias for `trigger`", (done) ->
      m = new mvc.Model
      m.on "ev", -> done()
      m.emit "ev"

  describe "collection", ->

    it "should have the `emit` alias for `trigger`", (done) ->
      m = new mvc.Collection
      m.on "ev", -> done()
      m.emit "ev"

  describe "view", ->

    it "`renderer` method should render outerHTML", ->
      m = new fixtures.Item
        title: "test"
        content: "hello world"
      v = new fixtures.ItemView
        model: m
      v.render()
      v.$el.data("view").should.match /^view[0-9]+$/
      v.$el.find("h3").text().should.equal "test"

    it "`renderer` method should render subViews", ->
      c = new fixtures.List [
        {title: "test1", content: "hello world"}
        {title: "test2", content: "hello tests"}
      ]
      v = new fixtures.ListView
        collection: c
      v.render()
      v.$el.find("h2").text().should.equal "Hello list"
      v.$el.find("h3")[0].innerHTML.should.equal "test1"
      v.$el.find("h3")[1].innerHTML.should.equal "test2"
