class App.Components.Dropdown extends Backbone.View

  el: 'body'

  initialize: ->
    for menu in $('nav.dropdown')
      $(menu).siblings('.button').first().click (e) ->
        e.preventDefault()
        $(menu).toggleClass('active')
