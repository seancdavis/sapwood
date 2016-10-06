class App.Components.ElementMultiSelect extends Backbone.View

  el: 'body'

  events:
    'click .selected-options li a': 'removeOption'

  initialize: (@container) ->
    @elementIds = @container.find('input').first().val().split(',')
      .filter(Boolean)
    @select = @container.find('select').first()
    @select.change (e) =>
      opt = @select.find('option:selected')
      @container.find('.selected-options').append """
        <li data-id="#{opt.val()}">
          <span>#{opt.text()}</span>
          <a href="#" class="remove">REMOVE</a>
        </li>
        """
      @elementIds.push(opt.val())
      @container.find('input').first().val(@elementIds.join(','))
      @select.find('option.placeholder').prop('selected', true)

  removeOption: (e) ->
    e.preventDefault()
    @elementIds = @container.find('input').first().val().split(',')
      .filter(Boolean)
    id = $(e.target).parents('li').data('id').toString()
    @elementIds = _.without(@elementIds, id)
    $(e.target).parents('li').remove()
    @container.find('input').first().val(@elementIds.join(','))
