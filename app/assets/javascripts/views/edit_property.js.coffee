class App.Views.EditProperty extends Backbone.View

  el: 'body'

  events:
    'keyup #property_color': 'updateColorBlock'
    'change input.label-visibility': 'updateHiddenLabels'

  initialize: ->
    @updateColorBlock()
    @updateHiddenLabels()

  updateColorBlock: ->
    $('span.color-block').css('backgroundColor', $('#property_color').val())

  updateHiddenLabels: ->
    $('div.label-input').removeClass('hidden')
    hidden = []
    for item in $('input.label-visibility:not(:checked)')
      $(item).parents('.label-input').addClass('hidden')
      hidden.push $(item).data('label')
    $('#property_hidden_labels').val("#{hidden.join(',')}")
