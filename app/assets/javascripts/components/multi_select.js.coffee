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

  # Target is the field in which the ids are rendered (comma-separated).
  #
  initTarget: ->
    @target = $(@el.data('multi-select'))

  # Container wraps the select for easier access to selected components.
  #
  initContainer: ->
    @el.wrap("<div class=\"multi-select-container\"></div>")
    @container = @el.parent()

  # Selected container is where the selected items are dropped.
  #
  initSelectedContainer: ->
    @container.append("<ul class=\"selected-container\"></ul>")
    @selectedContainer = @container.find('.selected-container').first()

  # Values is an array that holds the values and labels for the selected items.
  #
  # At first we want to check the target to see if there are any existing items
  # that should appear as being selected.
  #
  initValues: ->
    @values = []
    for value in _.compact(@target.val().split(','))
      option = @el.find("option[value='#{value}']")
      @addValue(option.val(), option.text())

  # Adds the value to the selected list, the values array, and the target field.
  #
  addValue: (value, label = value) ->
    return unless value
    @selectedContainer.append """
      <li data-id="#{value}"><span>#{label}</span><a href="javascript:void(0)" class="remove">REMOVE</a></li>
    """
    @values.push({ value: value, label: label })
    @writeToTarget()

  # Removes value from selected list, values array, and target field.
  #
  removeValue: (value) ->
    return unless value
    @selectedContainer.find("li[data-id='#{value}']").remove()
    @values = _.without(@values, _.findWhere(@values, { value: value }))
    @writeToTarget()

  # Writes the current set of selected values to the target field.
  #
  writeToTarget: ->
    values = _.map(@values, (item) -> item.value)
    @target.val(values.join(','))

  # Binds event listeners to selecting an item in the select field as well as
  # choosing to remove an option from the selected list.
  #
  initEvents: ->
    @el.change((event) =>
      @addValue(@el.val(), @el.find(':selected').text())
    )
    @container.on('click', '.selected-container', (event) =>
      id = $(event.target).parent().data('id')
      @removeValue(id)
    )

$(document).ready(Sapwood.MultiSelect.init)
