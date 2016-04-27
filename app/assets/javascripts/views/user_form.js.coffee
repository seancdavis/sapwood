class App.Views.UserForm extends Backbone.View

  el: 'body'

  events:
    'change #user_is_admin': 'setPropertiesVisibility'

  initialize: ->
    @setPropertiesVisibility()
    for li in $('.body aside li')
      $(li).addClass('clickable')
      $(li).find('.label').click (e) ->
        $(e.target).parents('li').find('input').trigger('click')

  setPropertiesVisibility: ->
    if $('#user_is_admin').is(':checked')
      $('aside .admin').show()
      $('aside .non-admin').hide()
    else
      $('aside .admin').hide()
      $('aside .non-admin').show()