class App.Components.Modal extends Backbone.View

  el: 'body'

  template: JST['templates/modal']

  initialize: (@title = '', @content = '') ->
    $('body').prepend(@template(title: @title, content: @content))
    @modal().find('.close-modal').click(@close)

  modal: =>
    $('body').find('#modal')

  fetch: (url, @title, done) ->
    @updateTitle()
    $.get url, (@content) =>
      @updateContent(@content)
      @open()
      done()

  updateTitle: =>
    @modal().find('h1').first().text(@title)

  updateContent: =>
    @modal().find('.modal-content').first().html(@content)

  open: =>
    @modal().addClass('active')

  close: (e = null) =>
    e.preventDefault() if e
    @modal().removeClass('active')
