class App.Views.EditProperty extends Backbone.View

  el: 'body'

  events:
    'keyup #property_color': 'updateColorBlock'

  initialize: ->
    @updateColorBlock()

  updateColorBlock: ->
    $('span.color-block').css('backgroundColor', $('#property_color').val())
