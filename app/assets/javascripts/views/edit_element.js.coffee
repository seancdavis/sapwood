class App.Views.EditElement extends Backbone.View

  el: 'body'

  initialize: (options) ->
    new App.Components.DocumentChooser(property_id: options.property_id)
    new App.Components.BulkDocumentChooser(property_id: options.property_id)
    new App.Components.Geocoder($(geocoder)) for geocoder in $('div.geocoder')
    for uploader in $('form .document-uploader')
      new App.Components.ElementUploader($(uploader))
    for bulkUploader in $('form .bulk-document-uploader')
      new App.Components.BulkElementUploader($(bulkUploader))
    $(wysiwyg).trumbowyg() for wysiwyg in $('textarea.wysiwyg')
    App.Components.Blocks.set()
