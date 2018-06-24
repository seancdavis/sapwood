class App.Views.Elements extends Backbone.View

  el: 'body'

  events:
    'click .dropdown-trigger': 'toggleTemplateDropdown'

  toggleTemplateDropdown: (e) ->
    e.preventDefault()
    selector = $(e.target).data('trigger-dropdown')
    $(selector).toggleClass('active')
