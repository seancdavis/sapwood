class App.Components.ElementUploader extends Backbone.View

  el: 'body'

  initialize: (@container) ->
    @renderUploader()

  renderUploader: ->
    $.get @container.data('uploader'), (response) =>
      @id = $(response).data('uid')
      $('form').after(response)
      @uploader = $("#uploader-#{@id}")
      @uploadForm = $("#fileupload-#{@id}")
      @bindEvents()
      @initUploader()

  bindEvents: ->
    @container.find('.upload-trigger').click (e) =>
      e.preventDefault()
      @uploadForm.find('#file').click()

  initUploader: ->
    $("#fileupload-#{@id}").fileupload
      add: (e, data) =>
        file = data.files[0]
        data.context = $(tmpl("template-upload", file))
        @container.find('label').first().after(data.context)
        data.context.find('.processing').hide()
        data.form.find('#content_type').attr('name','Content-Type')
        data.form.find('#content_type').val(file.type)
        data.submit()

      progress: (e, data) =>
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')

      done: (e, data) =>
        file = data.files[0]
        domain = @uploadForm.attr('action')
        path = @uploadForm.find('input[name=key]').val().replace('${filename}', file.name)
        to = @uploadForm.data('post')
        content = {}
        content[@uploadForm.data('as')] = domain + path
        $.post to, content
        .done (response) =>
          data.context.find('.progress').remove()
          data.context.append """
            <p class="success">Uploaded successfully.</p>
          """
          @container.find('input').first().val(response.document.id)
        .fail (response) =>
          data.context.find('.progress').remove()
          data.context.append """
            <p class="error">There was an error with this upload.</p>
          """

      fail: (e, data) ->
        $('div.upload').remove()
        $('header.page').after """
          <p class="alert">There was a problem with your upload.</p>
            """

