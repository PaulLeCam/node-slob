{mvc} = require "../../../src/framework"
Item = require "../models/item"

module.exports = class List extends mvc.Collection

  model: Item
