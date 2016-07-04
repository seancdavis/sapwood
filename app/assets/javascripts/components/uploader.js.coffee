class App.Components.Uploader extends Backbone.View

  el: 'body'

  template: JST['templates/upload']

  events:
    'click a.new.button': 'fauxFormClick'

  initialize: ->
    @initUploader()

  fauxFormClick: (e) ->
    e.preventDefault()
    $('#fileupload').find('#file').click()

  initUploader: ->
    $("#fileupload").fileupload
      add: (e, data) ->
        types = /(\.|\/)(gif|jpe?g|png|pdf|xlsx?|docx?|pptx?|csv)$/i
        file = data.files[0]
        if types.test(file.type) || types.test(file.name)
          data.context = $(tmpl("template-upload", file))
          $('.batch-uploader').append(data.context)
          data.context.find('.processing').hide()
          data.form.find('#content_type').attr('name','Content-Type')
          data.form.find('#content_type').val(file.type)
          data.submit()
        else
          alert("#{file.name} is not a supported format.")

      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
          data.context.find('.waiting').remove()

      done: (e, data) =>
        file = data.files[0]
        domain = $('#fileupload').attr('action')
        path = $('#fileupload input[name=key]').val().replace('${filename}', file.name)
        to = $('#fileupload').data('post')
        content = {}
        content[$('#fileupload').data('as')] = domain + path
        $.post to, content
        .done (response) =>
          data.context.find('.progress').remove()
          data.context.append """
            <p class="success">Uploaded successfully!</p>
          """
          window.location.reload() if $('div.progress').length == 0
        .fail (response) =>
          data.context.find('.progress').remove()
          data.context.append """
            <p class="error">There was an error with this upload.</p>
          """
          window.location.reload() if $('div.progress').length == 0

      fail: (e, data) ->
        $('div.upload').remove()
        $('header.page').after """
          <p class="alert">There was a problem with your upload.</p>
            """
