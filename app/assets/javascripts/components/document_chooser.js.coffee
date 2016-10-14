class App.Components.DocumentChooser extends Backbone.View

  el: 'body'

  events:
    'click .document-chooser': 'openModal'
    'click .modal-doc-chooser .modal-content .document > a': 'chooseDocument'
    'click .modal-doc-chooser .document-filters a': 'filterDocuments'
    'click .modal-doc-chooser .pagination a': 'filterDocuments'

  initialize: (options) ->
    # @url = "/properties/#{options.property_id}/documents"
    @modal = new App.Components.Modal

  openModal: (e) ->
    e.preventDefault()
    @uploader = $(e.target).parents('.document-uploader')
    @modal.fetch $(e.target).attr('href'), 'Choose Document', () =>
      @modal.modal().addClass('modal-doc-chooser')

  chooseDocument: (e) ->
    e.preventDefault()
    doc = $(e.target).parents('article.document').first()
    @uploader.find('input.hidden').first().val(doc.data('id'))
    preview = @uploader.find('.document-url').first()
    preview.find('a').attr('href', doc.data('url'))
    preview.find('img').remove()
    if doc.data('image')
      preview.find('span').before("<img src=\"#{doc.data('url')}\">")
    preview.find('span').text(doc.data('title'))
    preview.removeClass('hidden')
    @modal.close()

  filterDocuments: (e) ->
    e.preventDefault()
    $.get $(e.target).attr('href'), (data) =>
      @modal.content = data
      @modal.updateContent()
      @bindClickEvents()
