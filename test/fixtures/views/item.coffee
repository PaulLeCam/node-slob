{mvc, template} = require "../../../src/framework"
tmpl = template.compile require("fs").readFileSync("#{ __dirname }/../templates/item.htm").toString()

module.exports = class Item extends mvc.View

  tagName: "li"
  template: tmpl

  render: ->
    @renderer @template @model.toJSON()
