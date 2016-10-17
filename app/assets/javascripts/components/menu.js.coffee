class App.Components.Menu extends Backbone.View

  el: 'aside.main'

  events:
    'click .toggle-sub-menu': 'toggleSubMenu'

  toggleSubMenu: (e) ->
    e.preventDefault()
    $(e.target).siblings('ul').toggleClass('active')
