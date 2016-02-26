class App.Routers.Router extends Backbone.Router

  initialize: ->
    new App.Components.Notices
    new App.Components.Blocks
    new App.Components.Helpers

  routes:
    'properties/:property_id/edit': 'editProperty'
    'properties/:property_id/elements': 'elements'
    'properties/:property_id/documents': 'documents'

  editProperty: ->
    new App.Views.EditProperty

  elements: ->
    new App.Views.Elements

  documents: ->
    new App.Components.Uploader
