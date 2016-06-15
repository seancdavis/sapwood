class App.Components.DocumentChooser extends Backbone.View

  el: 'body'

  events:
    'click .document-chooser': 'openModal'

  initialize: (options) ->
    @url = "/properties/#{options.property_id}/documents"
    @modal = new App.Components.Modal

  openModal: (e) ->
    e.preventDefault()
    @uploader = $(e.target).parents('.document-uploader')
    if @modal.title == 'Chose Document'
      @modal.open()
    else
      @modal.fetch @url, 'Choose Document', () =>
        @bindClickEvents()

  bindClickEvents: =>
    @modal.modal().find('.modal-content a').click (e) =>
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
