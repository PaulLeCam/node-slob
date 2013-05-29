{template} = require "./framework"

# Set the base path used to load files
module.exports = (base_path) ->

  (req, res, next) ->

    # Base data
    res.locals.app_data =
      data: []
      views: []

    # Load, instanciate and add model or collection to data set
    createData = (file_path, data, name) ->
      Cls = require "#{ base_path }/#{ file_path }"
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

    # Load and instanciate view, and return its content
    res.locals.view = (type, params = {}) ->
      view_path = "views/#{ type }"
      View = require "#{ base_path }/#{ view_path }"
      view = new View params
      params.cid = view.cid
      # Transform `model` and `collection` params to be sent to client
      params.model = params.model.toJSON() if params.model
      params.collection = params.collection.toJSON() if params.collection
      res.locals.app_data.views.push
        load: view_path
        data: params
      view.render()

    # Render template
    res.locals.template = (name, data = {}) ->
      template.load("#{ base_path }/templates/#{ name }") data

    next()
