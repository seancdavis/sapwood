class App.Components.Avatar extends Backbone.View

  el: 'body'

  template: JST['templates/upload']

  events:
    'click a.upload-avatar': 'fauxFormClick'

  initialize: ->
    @initUploader()

  fauxFormClick: (e) ->
    e.preventDefault()
    $('#fileupload').find('#file').click()

  initUploader: ->
    $("#fileupload").fileupload
      add: (e, data) ->
        file = data.files[0]
        data.context = $(tmpl("template-upload", file))
        $('a.upload-avatar').before(data.context)
        data.context.find('.processing').hide()
        data.form.find('#content_type').attr('name','Content-Type')
        data.form.find('#content_type').val(file.type)
        data.submit()

      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
          data.context.find('.waiting').remove()

      done: (e, data) =>
        file = data.files[0]
        domain = $('#fileupload').attr('action')
        path = $('#fileupload input[name=key]').val().replace('${filename}', file.name)
        $('#user_avatar_url').val(domain + path)
        $('form img.avatar').attr('src', domain + path)
        data.context.remove()

      fail: (e, data) ->
        $('div.upload').remove()
        $('header.page').after """
          <p class="alert">There was a problem with your upload.</p>
            """
