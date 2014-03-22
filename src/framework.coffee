Backbone = require "backbone"
React = require "react"

Backbone.$ = require "./jquery"

# ## Model

class Model extends Backbone.Model

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

# ## View (React)

View = React

# ## Public API

module.exports = {Model, Collection, View}
