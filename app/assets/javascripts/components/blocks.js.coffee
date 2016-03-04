class App.Components.Blocks extends Backbone.View

  el: 'body'

  initialize: ->
    for aside in $('div.block').find('aside')
      if $(aside).outerHeight() < $(aside)[0].scrollHeight
        $(aside).parents('.block').first().outerHeight($(aside)[0].scrollHeight)

  @reset: ->
    $('div.block').css(height: 'auto')
