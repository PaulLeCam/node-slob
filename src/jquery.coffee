# ## Expose jQuery server-side for Backbone, as we need to render views

window = require("jsdom").jsdom().parentWindow
module.exports = require("jquery") window
