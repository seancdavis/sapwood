class App.Views.EditElement extends Backbone.View

  el: 'body'

  initialize: (options) ->
    new App.Components.DocumentChooser(property_id: options.property_id)
    new App.Components.BulkDocumentChooser(property_id: options.property_id)
    for uploader in $('form .document-uploader')
      new App.Components.ElementUploader($(uploader))
    for bulkUploader in $('form .bulk-document-uploader')
      new App.Components.BulkElementUploader($(bulkUploader))
    for multiselect in $('form div.multiselect')
      new App.Components.ElementMultiSelect($(multiselect))
    for wysiwyg in $('textarea.wysiwyg')
      $(wysiwyg).trumbowyg
        autogrow: true
        svgPath: TRUMBOWYG_ICON_PATH
    for datepicker in $('div.pickadate input')
      $(datepicker).pickadate({ format: $(datepicker).data('format') })
    App.Components.Blocks.set()
