class App.Views.EditElement extends Backbone.View

  el: 'body'

  initialize: ->
    new App.Components.Geocoder($(geocoder)) for geocoder in $('div.geocoder')
