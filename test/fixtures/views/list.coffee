{mvc, template} = require "../../../src/framework"
Item = require "./item"
tmpl = template.compile require("fs").readFileSync("#{ __dirname }/../templates/list.htm").toString()

template.registerHelper "item", (model = {}) ->
  template.addSubView new Item {model}

module.exports = class List extends mvc.View

  template: tmpl

  render: ->
    @renderer @template
      title: "Hello list"
      items: @collection.models
