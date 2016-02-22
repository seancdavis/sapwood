class App.Views.Elements extends Backbone.View

  el: 'body'

  events:
    'click .new.button': 'toggleTemplateDropdown'

  toggleTemplateDropdown: (e) ->
    e.preventDefault()
    $('header.page nav.dropdown').toggleClass('active')
