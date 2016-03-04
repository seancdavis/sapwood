class App.Components.CollectionBuilder extends Backbone.View

  el: 'body'

  container: $('.collection-builder')

  template: JST['templates/collections/item']
  newTemplate: JST['templates/collections/new_item']

  events:
    'change .collection-builder select': 'addItem'
    'keydown form': 'preventEnter'

  initialize: ->
    @fetchElements()

  fetchElements: ->
    $.getJSON @container.data('elements'), (data) =>
      @elements = data
      @appendNewFormTo(@container)

  preventEnter: (e) ->
    e.preventDefault() if e.keyCode == 13

  addItem: (e) ->
    e.preventDefault()
    dropdown = $(e.target)
    form = dropdown.parents('.new-item')
    parent = form.parent()
    nextLevel = parseInt(parent.attr('data-level')) + 1
    element =
      id: dropdown.val()
      title: dropdown.find('option:selected').text()
      level: nextLevel
    form.remove()
    item = @appendElementTo(parent, element)
    @appendNewFormTo(item) unless nextLevel == 3
    @appendNewFormTo(parent)
    @updateData()

  appendElementTo: (parent, element) ->
    parent.append(@template(element: element))
    parent.find('.item').last()

  appendNewFormTo: (parent) ->
    parent.append(@newTemplate(elements: @elements))

  updateData: ->
    data = []
    for one, i in @container.children('.item')
      data.push
        id: parseInt($(one).attr('data-id'))
        title: $(one).children('span.title').text()
        children: []
      if $(one).children('.item').length > 0
        for two, j in $(one).children('.item')
          data[i].children.push
            id: parseInt($(two).attr('data-id'))
            title: $(two).children('span.title').text()
            children: []
          if $(two).children('.item').length > 0
            for three, k in $(two).children('.item')
              data[i].children[j].children.push
                id: parseInt($(three).attr('data-id'))
                title: $(three).children('span.title').text()
    $('#collection_item_data').val(JSON.stringify(data))
