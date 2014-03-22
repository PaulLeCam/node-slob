{View} = require "../../../src/framework"
{h3, p, li} = View.DOM

module.exports = View.createClass
  render: ->
    li {},
      h3 {}, @props.model.get "title"
      p {}, @props.model.get "content"
