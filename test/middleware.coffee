cheerio = require "cheerio"
express = require "express"
request = require "supertest"
middleware = require "../src/middleware"
fixtures = require "./fixtures"

describe "middleware", ->

  describe "locals", ->

    it "should have created object `app_data` in `locals` with values `data` and `views`", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
          res.locals.app_data.should.have.property("data").instanceof Array
          res.locals.app_data.should.have.property("views").instanceof Array
          res.end()

      request app
        .get "/"
        .expect 200
        .end done

    it "should have registered locals functions `model`, `collection` and `view`", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
          res.locals.model.should.be.an.instanceof Function
          res.locals.collection.should.be.an.instanceof Function
          res.locals.view.should.be.an.instanceof Function
          res.end()

      request app
        .get "/"
        .expect 200
        .end done

  describe "models and collections", ->

    it "should load and instantiate models and collections", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
          m = res.locals.model "item"
          m.should.be.an.instanceof fixtures.Item
          c = res.locals.collection "list"
          c.should.be.an.instanceof fixtures.List
          res.end()

      request app
        .get "/"
        .expect 200
        .end done

    it "should add named models and collections JSON data to `app_data` object", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
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
          res.end()

      request app
        .get "/"
        .expect 200
        .end done

  describe "views", ->

    it "should load, instantiate and render views", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
          m = res.locals.model "item",
            title: "test"
          html = res.locals.view "item",
            model: m
          $ = cheerio.load html
          $("h3").text().should.equal "test"
          res.end()

      request app
        .get "/"
        .expect 200
        .end done

    it "should add views collections to `app_data` object", (done) ->

      app = express()
        .use middleware "#{ __dirname }/fixtures"
        .use (req, res) ->
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
          res.end()

      request app
        .get "/"
        .expect 200
        .end done
