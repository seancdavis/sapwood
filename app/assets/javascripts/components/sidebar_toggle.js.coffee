class App.Components.SidebarToggle extends Backbone.View

  el: 'body'

  events:
    'click #sidebar-trigger': 'toggleSidebar'

  toggleSidebar: (e) ->
    e.preventDefault()
    $('#sidebar-trigger').toggleClass('active')
    $('aside.main').toggleClass('hidden')
    $('#container').toggleClass('sidebar')
