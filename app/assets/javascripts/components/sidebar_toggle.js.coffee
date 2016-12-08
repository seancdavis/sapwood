class App.Components.SidebarToggle extends Backbone.View

  el: 'body'

  events:
    'click #sidebar-trigger': 'toggleSidebar'

  toggleSidebar: (e) ->
    e.preventDefault()
    $('#sidebar-trigger').toggleClass('toggle')
    $('aside.main').toggleClass('toggle')
    $('#container').toggleClass('sidebar')
