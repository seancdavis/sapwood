class App.Routers.Router extends Backbone.Router

  initialize: ->
    return

  routes:
    'properties/:property_id/edit': 'editProperty'

  editProperty: ->
    new App.Views.EditProperty
