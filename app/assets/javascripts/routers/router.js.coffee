class App.Routers.Router extends Backbone.Router

  initialize: ->
    return

  routes:
    'properties/:property_id/edit': 'editProperty'
    'properties/:property_id/elements': 'elements'

  editProperty: ->
    new App.Views.EditProperty

  elements: ->
    new App.Views.Elements
