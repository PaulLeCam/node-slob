module.exports = (path) ->

  (req, res, next) ->

    res.locals.app_data =
      data: []
      views: []

    createData = (client_path, data, name) ->
      Cls = require "#{ path }/#{ client_path }"
      item = new Cls data
      if name? then res.locals.app_data.data.push
        key: name
        load: client_path
        data: item.toJSON()
      item

    res.locals.collection = (type, models, name) ->
      createData "collections/#{ type }", models, name

    res.locals.model = (type, data, name) ->
      createData "models/#{ type }", data, name

    res.locals.view = (type, params = {}) ->
      rel_path = "views/#{ type }"
      View = require "#{ path }/#{ rel_path }"
      view = new View params
      params.cid = view.cid
      params.model = params.model.toJSON() if params.model
      params.collection = params.collection.toJSON() if params.collection
      res.locals.app_data.views.push
        load: rel_path
        data: params
      view.render()

    next()
