class App.Views.UserForm extends Backbone.View

  el: 'body'

  events:
    'change #user_is_admin': 'setPropertiesVisibility'
    'change .switch.access-editor input': 'toggleAdmin'
    'change .switch.access-admin input': 'toggleEditor'
    'click .body aside .clickable .label': 'toggleInput'

  initialize: ->
    @setPropertiesVisibility()

  toggleInput: (e) ->
    $(e.currentTarget).parents('.clickable').find('input').trigger('click')

  setPropertiesVisibility: ->
    if $('#user_is_admin').is(':checked')
      $('aside .admin').show()
      $('aside .non-admin').hide()
    else
      $('aside .admin').hide()
      $('aside .non-admin').show()

  toggleAdmin: (e) ->
    unless $(e.currentTarget).is(':checked')
      $(e.currentTarget).parents('li').find('.access-admin input')
        .prop('checked', false)

  toggleEditor: (e) ->
    if $(e.currentTarget).is(':checked')
      $(e.currentTarget).parents('li').find('.access-editor input')
        .prop('checked', true)
