class App.Components.Geocoder extends Backbone.View

  el: 'body'

  template: JST['templates/geocoder']

  events:
    'change .geocoder textarea': 'updateAddress'

  initialize: (@container) ->
    @container.append "<div class='geocode-results'></div>"
    App.Components.Blocks.set()
    @updateAddress()

  updateAddress: ->
    q = @container.find('textarea').first().val()
    unless q
      @container.find('.geocode-results').html('')
      return false
    @container.find('.geocode-results').html("<em>Looking up ...</em>")
    url ="/geocoder/search?q=#{q}"
    $.get url, (data) =>
      if data.success
        @container.find('.geocode-results').html("<p>#{data.full_address}</p>")
        App.Components.Blocks.set()
      else
        @container.find('.geocode-results').html("<p>Could not locate.</p>")
