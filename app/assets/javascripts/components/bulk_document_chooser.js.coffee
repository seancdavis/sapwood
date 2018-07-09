class App.Components.BulkDocumentChooser extends Backbone.View

  el: 'body'

  events:
    'click .bulk-document-chooser': 'openModal'
    'click .bulk-doc-modal .modal-content .document > a': 'addDocument'
    'click .bulk-doc-modal .document-filters a': 'filterDocuments'
    'click .bulk-doc-modal .pagination a': 'filterDocuments'
    'click #save-bulk': 'saveDocuments'
    'click .bulk-document-uploader a.remove': 'removeDocument'

  initialize: (options) ->
    @modal = new App.Components.Modal
    @initSortable($(sortable)) for sortable in $('.bulk-document-uploader')

  openModal: (e) ->
    e.preventDefault()
    @uploader = $(e.target).parents('.bulk-document-uploader')
    @documentIds = @uploader.find('input.hidden').first().val().split(',')
      .filter(Boolean)
    @modal.fetch $(e.target).attr('href'), 'Choose Documents', () =>
      @addBulkSaveButton()
      @modal.modal().addClass('bulk-doc-modal')

  addDocument: (e) ->
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

  filterDocuments: (e) ->
    e.preventDefault()
    $.get $(e.target).attr('href'), (data) =>
      @modal.content = data
      @modal.updateContent()

  saveDocuments: (e) ->
    e.preventDefault()
    @uploader.find('input.hidden').first().val(@documentIds.join(','))
    for doc in $('article.document.selected')
      preview = @uploader.find('.document-url.hidden').first().clone()
      preview.append """
        #{$(doc).find('span.thumb').html()}
        <a href=\"#{$(doc).data('url')}\">#{$(doc).data('title')}</a>
        <a href="#" class="remove">REMOVE</a>
      """
      preview.attr('data-id', $(doc).data('id'))
      @uploader.find('.selected-documents').append(preview)
      preview.removeClass('hidden')
    @modal.close()

  addBulkSaveButton: () =>
    if $('#save-bulk').length == 0
      $('.document-tiles').before """
        <div style="margin-bottom:3rem;">
          <a href="#" id="save-bulk" class="button">Save & Close</a>
        </div>
        """

  removeDocument: (e) ->
    e.preventDefault()
    container = $(e.target).parents('.bulk-document-uploader')
    @documentIds = container.find('input').first().val().split(',')
      .filter(Boolean)
    id = $(e.target).parents('li').data('id').toString()
    @documentIds = _.without(@documentIds, id)
    $(e.target).parents('li').remove()
    container.find('input').first().val(@documentIds.join(','))

  initSortable: (container) ->
    container.find('ul.selected-documents').first().sortable
      update: (event, ui) ->
        ids = $(this).sortable('toArray', { attribute: 'data-id' })
        $(this).parents('.bulk-document-uploader').find('input.hidden')
          .val(ids.join(','))
