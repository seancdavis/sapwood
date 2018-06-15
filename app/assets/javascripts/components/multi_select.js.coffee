class Sapwood.MultiSelect

  @init: ->
    new Sapwood.MultiSelect(el) for el in $('[data-multi-select]')

  constructor: (el) ->
    @el = $(el)
    @initTarget()
    @initContainer()
    @initSelectedContainer()
    @initValues()
    @initEvents()

  initTarget: ->
    @target = $(@el.data('multi-select'))

  initContainer: ->
    @el.wrap("<div class=\"multi-select-container\"></div>")
    @container = @el.parent()

  initSelectedContainer: ->
    @container.append("<ul class=\"selected-container\"></ul>")
    @selectedContainer = @container.find('.selected-container').first()

  initValues: ->
    @values = []
    for value in _.compact(@target.val().split(','))
      option = @el.find("option[value='#{value}']")
      @addValue(option.val(), option.text())

  addValue: (value, label = value) ->
    return unless value
    @selectedContainer.append """
      <li data-id="#{value}"><span>#{label}</span><a href="javascript:void(0)" class="remove">REMOVE</a></li>
    """
    @values.push({ value: value, label: label })
    @writeToTarget()

  removeValue: (value) ->
    return unless value
    @selectedContainer.find("li[data-id='#{value}']").remove()
    @values = _.without(@values, _.findWhere(@values, { value: value }))
    @writeToTarget()

  writeToTarget: ->
    values = _.map(@values, (item) -> item.value)
    @target.val(values.join(','))

  initEvents: ->
    @el.change((event) =>
      @addValue(@el.val(), @el.find(':selected').text())
    )
    @container.on('click', '.selected-container', (event) =>
      id = $(event.target).parent().data('id')
      @removeValue(id)
    )

$(document).ready(Sapwood.MultiSelect.init)
