# ## Expose jQuery server-side for Backbone, as we need to render views

jsdom = require("jsdom").jsdom
jquery = require("fs").readFileSync("#{ __dirname }/../lib/jquery-2.0.1.js").toString()
doc = jsdom "<html><head><script>#{ jquery }</script></head><body></body></html>"

module.exports = doc.createWindow().$
