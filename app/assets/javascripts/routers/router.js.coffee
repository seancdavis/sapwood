class App.Routers.Router extends Backbone.Router

  initialize: ->
    new App.Components.Notices
    new App.Components.Blocks
    new App.Components.Helpers
    new App.Components.SidebarToggle
    new App.Components.Dropdown
    new App.Components.Menu
    new App.Components.Search

  routes:
    'properties/:property_id/edit': 'editProperty'
    'properties/:property_id/elements/:template/new': 'editElement'
    'properties/:property_id/elements/:template/:element_id/edit': 'editElement'
    'properties/:property_id/documents/:template': 'documents'
    'properties/:property_id/users/new': 'user'
    'properties/:property_id/users/:user_id/edit': 'user'

  editProperty: ->
    new App.Views.EditProperty

  editElement: (property_id) ->
    new App.Views.EditElement
      property_id: property_id

  documents: ->
    new App.Components.Uploader

  user: ->
    new App.Views.UserForm
