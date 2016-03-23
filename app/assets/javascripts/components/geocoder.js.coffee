class App.Components.Geocoder extends Backbone.View

  el: 'body'

  initialize: (@container) ->
    @initMap()

  initMap: ->
    L.mapbox.accessToken = @container.data('mapbox')
    id = "map-#{@randomKey()}"
    @container.append "<div id=\"#{id}\" class=\"map\"></div>"
    @map = L.mapbox.map(id, 'mapbox.streets').setView([39.7, -98.66], 5);
    App.Components.Blocks.reset()

  randomKey: ->
    'xxxxxxxxxxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = if c == 'x' then r else r & 0x3 | 0x8
      v.toString 16
