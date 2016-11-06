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
    'properties/:property_id': 'propertyDash'
    'properties/:property_id/settings/general': 'editProperty'
    'properties/:property_id/settings/config': 'codeEditor'
    'properties/:property_id/elements/:template/new': 'editElement'
    'properties/:property_id/elements/:template/:element_id/edit': 'editElement'
    'properties/:property_id/documents/:template': 'documents'
    'properties/:property_id/users/new': 'user'
    'properties/:property_id/users/:user_id/edit': 'user'
    'properties/:property_id/profile/edit': 'profile'
    'profile/edit': 'profile'

  propertyDash: ->
    $('.search input').first().focus()

  editProperty: ->
    new App.Views.EditProperty

  codeEditor: ->
    new App.Components.CodeEditor(textarea: '#property_templates_raw')

  editElement: (property_id) ->
    new App.Views.EditElement
      property_id: property_id

  documents: ->
    new App.Components.Uploader

  user: ->
    new App.Views.UserForm

  profile: ->
    new App.Components.Avatar
