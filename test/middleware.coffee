$ = require "../src/jquery"
express = require "express"
request = require "supertest"
middleware = require "../src/middleware"
fixtures = require "./fixtures"

makeRequest = (app, done) ->
  request(app).get("/").end (err, res) ->
    throw new Error res.body.message if res.body.name is "AssertionError"
    done()

describe "middleware", ->

  describe "locals", ->

    it "should have created object `app_data` in `locals` with values `data` and `views`", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"

      app.get "/", (req, res) ->
        try
          res.locals.app_data.should.have.property("data").instanceof Array
          res.locals.app_data.should.have.property("views").instanceof Array
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

    it "should have registered locals functions `model`, `collection` and `view`", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"

      app.get "/", (req, res) ->
        try
          res.locals.should.have.property("model").instanceof Function
          res.locals.should.have.property("collection").instanceof Function
          res.locals.should.have.property("view").instanceof Function
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

  describe "models and collections", ->

    it "should load and instanciate models and collections", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
      
      app.get "/", (req, res) ->
        try
          m = res.locals.model "item"
          m.should.be.an.instanceof fixtures.Item
          c = res.locals.collection "list"
          c.should.be.an.instanceof fixtures.List
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

    it "should add named models and collections JSON data to `app_data` object", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
      
      app.get "/", (req, res) ->
        try
          m = res.locals.model "item", {id: 1, title: "test"}, "MyItem"
          res.locals.model "item", {} # No name, should not be added
          res.locals.collection "list", [m], "MyList"
          res.locals.app_data.data.should.have.property("length").equal 2
          res.locals.app_data.data[0].should.eql
            key: "MyItem"
            load: "models/item"
            data:
              id: 1
              title: "test"
          res.locals.app_data.data[1].should.eql
            key: "MyList"
            load: "collections/list"
            data: [
              id: 1
              title: "test"
            ]
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

  describe "views", ->

    it "should load, instanciate and render views", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
      
      app.get "/", (req, res) ->
        try
          m = res.locals.model "item",
            title: "test"
          html = res.locals.view "item",
            model: m
          $(html).find("h3").text().should.equal "test"
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

    it "should add views collections to `app_data` object", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
      
      app.get "/", (req, res) ->
        try
          m = res.locals.model "item",
            id: 1
            title: "test"
          res.locals.view "item",
            model: m
          res.locals.app_data.views.should.have.property("length").equal 1
          res.locals.app_data.views[0].should.have.property("load").equal "views/item"
          res.locals.app_data.views[0].should.have.property("data").property("model").eql
            id: 1
            title: "test"
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done

  describe "template", ->

    it "should render template into HTMl content", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
      
      app.get "/", (req, res) ->
        try
          html = res.locals.template "item.htm",
            title: "test"
            content: "test"
          html.should.equal """
          <h3>test</h3>
          <p>test</p>

          """
        catch e
          return res.send 500, e
        res.end()

      makeRequest app, done
