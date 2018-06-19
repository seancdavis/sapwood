#= require jquery
#= require jquery_ujs
#= require jquery-ui/sortable
#= require codemirror/codemirror
#= require codemirror/keymap/sublime
#= require codemirror/mode/javascript
#= require pickadate/picker
#= require pickadate/picker.date
#= require underscore
#= require backbone
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require trumbowyg
#= require trumbowyg.cleanpaste
#= require_self
#= require_tree ./templates
#= require_tree ./components
#= require_tree ./views
#= require_tree ./routers

window.App =
  Components: {}
  Routers: {}
  Views: {}

window.Sapwood = {}

$(document).ready ->
  new App.Routers.Router

  # Enable pushState for compatible browsers
  enablePushState = true

  # Disable for older browsers
  pushState = !!(enablePushState && window.history && window.history.pushState)

  Backbone.history.start({ pushState: pushState })
