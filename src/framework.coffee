fs = require "fs"
Backbone = require "backbone"
Handlebars = require "handlebars"

Backbone.$ = require "./jquery"

# ## Template

template = Handlebars
subviews = {}

# Add a "safe" helper to render raw HTML
template.registerHelper "safe", (html) ->
  new template.SafeString html

# Load and compile HTML content
template.load = (file) ->
  template.compile fs.readFileSync(file).toString()

# Add a view to the local registry and return a DOM element that we can identify
template.addSubView = (view) ->
  subviews[view.cid] = view
  new template.SafeString "<view data-cid=\"#{ view.cid }\"></view>"

# Return the DOM element of a stored view and delete it from the registry
template.renderSubView = (cid) ->
  if view = subviews[cid]
    delete subviews[cid]
    view.render()
  else ""

# Render all subviews present in a DOM element identified by a jQuery object
template.renderSubViews = ($el) ->
  $el.find("view").each (i, view) ->
    $view = $el.find view
    $view.replaceWith template.renderSubView $view.data "cid"

# ## Model

class Model extends Backbone.Model

  # Required for compatibility with client-side code
  @Store = ->

  # Alias `trigger()` to `emit()` for consistency with Node's EventEmitter
  emit: ->
    @trigger.apply @, arguments

  # Add ID to exposed data
  toJSON: ->
    json = super()
    json.id ?= @id
    json

# ## Collection

class Collection extends Backbone.Collection

  # Alias `trigger()` to `emit()` for consistency with Node's EventEmitter
  emit: ->
    @trigger.apply @, arguments

# ## View

class View extends Backbone.View

  # Alias `trigger()` to `emit()` for consistency with Node's EventEmitter
  emit: ->
    @trigger.apply @, arguments

  # The `renderer()` set the HTML content for the element and render eventual associated subviews.
  # It returns the HTML element to be displayed by the view.
  renderer: (html) ->
    @$el
      .attr("data-view", @cid)
      .html html
    template.renderSubViews @$el
    @el.outerHTML

# ## Public API

mvc = {Model, Collection, View}
module.exports = {mvc, template}
