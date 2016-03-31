class App.Views.EditElement extends Backbone.View

  el: 'body'

  initialize: ->
    new App.Components.Geocoder($(geocoder)) for geocoder in $('div.geocoder')
    for uploader in $('form .document-uploader')
      new App.Components.ElementUploader($(uploader))
