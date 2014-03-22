{View} = require "../../../src/framework"
Item = require "./item"
{h2, div, ul} = View.DOM

module.exports = View.createClass
  render: ->
    items = {}
    @props.collection.models.forEach (model) ->
      items[ model.cid ] = Item {model}

    div {},
      h2 {}, @props.title
      ul {}, items
