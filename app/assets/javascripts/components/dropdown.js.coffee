class App.Components.Dropdown extends Backbone.View

  el: 'body'

  events:
    'click .dropdown > a': 'toggleDropdown'

  toggleDropdown: (e) ->
    e.preventDefault()
    $(e.target).parents('.dropdown').siblings('.dropdown').removeClass('active')
    $(e.target).parents('.dropdown').first().toggleClass('active')
