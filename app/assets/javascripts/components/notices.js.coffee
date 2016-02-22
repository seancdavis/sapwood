class App.Components.Notices extends Backbone.View

  el: 'body'

  initialize: ->
    for notice in $('p.notice, p.alert')
      $(notice).insertAfter($('header.page').first())
      $(notice).addClass('active')
