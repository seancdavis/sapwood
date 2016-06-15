class App.Routers.Router extends Backbone.Router

  initialize: ->
    new App.Components.Notices
    new App.Components.Blocks
    new App.Components.Helpers
    new App.Components.SidebarToggle

  routes:
    'properties/:property_id/edit': 'editProperty'
    'properties/:property_id/elements': 'elements'
    'properties/:property_id/elements/new': 'editElement'
    'properties/:property_id/elements/:element_id/edit': 'editElement'
    'properties/:property_id/documents': 'documents'
    'properties/:property_id/collections/new': 'collection'
    'properties/:property_id/collections/:collection_id/edit': 'collection'
    'properties/:property_id/users/new': 'user'
    'properties/:property_id/users/:user_id/edit': 'user'

  editProperty: ->
    new App.Views.EditProperty

  elements: ->
    new App.Views.Elements

  editElement: (property_id) ->
    new App.Views.EditElement
      property_id: property_id

  documents: ->
    new App.Components.Uploader

  collection: ->
    new App.Components.CollectionBuilder

  user: ->
    new App.Views.UserForm
