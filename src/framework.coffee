fs = require "fs"
Backbone = require "backbone"
Handlebars = require "handlebars"
$ = require("jquery").create null, "2.0"

#
# Template
#

template = Handlebars
subviews = {}

template.registerHelper "safe", (html) ->
  new template.SafeString html

template.load = (file) ->
  template.compile fs.readFileSync(file).toString()

template.addSubView = (view) ->
  subviews[view.cid] = view
  new template.SafeString "<view data-cid=\"#{ view.cid }\"></view>"

template.renderSubView = (cid) ->
  if view = subviews[cid]
    delete subviews[cid]
    view.render()
  else ""

template.renderSubViews = ($el) ->
  $el.find("view").each (i, view) ->
    $view = $ view
    $view.replaceWith template.renderSubView $view.data "cid"

template.registerHelper "subView", template.addSubView

#
# MVC
#

Backbone.$ = $

class Model extends Backbone.Model

  @Store = ->

  emit: ->
    @trigger.apply @, arguments

  toJSON: ->
    json = super()
    json.id ?= @id
    json

class Collection extends Backbone.Collection

  emit: ->
    @trigger.apply @, arguments

class View extends Backbone.View

  emit: ->
    @trigger.apply @, arguments

  renderer: (html) ->
    @$el
      .attr("data-view", @cid)
      .html html
    template.renderSubViews @$el
    @el.outerHTML

#
# Public API
#

mvc = {Model, Collection, View}
module.exports = {mvc, template}
