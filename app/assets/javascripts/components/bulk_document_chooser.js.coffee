class App.Components.BulkDocumentChooser extends Backbone.View

  el: 'body'

  events:
    'click .bulk-document-chooser': 'openModal'

  initialize: (options) ->
    @url = "/properties/#{options.property_id}/documents"
    @modal = new App.Components.Modal

  openModal: (e) ->
    e.preventDefault()
    @uploader = $(e.target).parents('.bulk-document-uploader')
    @documentIds = @uploader.find('input').first().val().split(',')
      .filter(Boolean)
    if @modal.title == 'Chose Documents'
      @modal.open()
      @addBulkSaveButton()
    else
      @modal.fetch @url, 'Choose Documents', () =>
        @addBulkSaveButton()
        @bindClickEvents()

  bindClickEvents: =>
    @modal.modal().find('.modal-content .document > a').click (e) =>
      e.preventDefault()
      doc = $(e.target).parents('article.document').first()
      if doc.hasClass('selected')
        @documentIds = _.without(@documentIds, doc.data('id'))
      else
        @documentIds.push(doc.data('id'))
      doc.toggleClass('selected')
      if $('article.document.selected').length > 0
        $('#save-bulk').addClass('active')
      else
        $('#save-bulk').removeClass('active')
    @modal.modal().find('.pagination a, .document-filters a').click (e) =>
      e.preventDefault()
      $.get $(e.target).attr('href'), (data) =>
        @modal.content = data
        @modal.updateContent()
        @bindClickEvents()
    $('#save-bulk').click (e) =>
      e.preventDefault()
      @uploader.find('input.hidden').first().val(@documentIds.join(','))
      for doc in $('article.document.selected')
        preview = @uploader.find('.document-url.hidden').first().clone()
        preview.append("<a href=\"#{$(doc).data('url')}\"></a>")
        preview.find('a').append """
          #{$(doc).find('span.thumb').html()}
          <span>#{$(doc).data('title')}</span>
        """
        @uploader.find('.document-url.hidden').before(preview)
        preview.removeClass('hidden')
      @modal.close()

  addBulkSaveButton: () =>
    if $('#save-bulk').length == 0
      $('.document-filters').before """
        <a href="#" id="save-bulk" class="button">Save & Close</a>
        """
