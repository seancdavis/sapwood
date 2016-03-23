class App.Components.Geocoder extends Backbone.View

  el: 'body'

  template: JST['templates/geocoder']

  events:
    'change .geocoder textarea': 'updateAddress'

  initialize: (@container) ->
    @container.append "<div class='geocode-results'></div>"
    App.Components.Blocks.set()

  updateAddress: ->
    @container.find('.geocode-results').html("<em>Looking up ...</em>")
    url ="/geocoder/search?q=#{@container.find('textarea').first().val()}"
    $.get url, (data) =>
      if data.success
        @container.find('.geocode-results').html("<p>#{data.full_address}</p>")
        @container.find('.full_address').val(data.full_address)
        @container.find('.street_address').val(data.street_address)
        @container.find('.city').val(data.city)
        @container.find('.state').val(data.state)
        @container.find('.zip').val(data.zip)
        @container.find('.country_code').val(data.country_code)
        @container.find('.lat').val(data.lat)
        @container.find('.lng').val(data.lng)
        App.Components.Blocks.set()
      else
        @container.find('.geocode-results').html("<p>Could not locate.</p>")
