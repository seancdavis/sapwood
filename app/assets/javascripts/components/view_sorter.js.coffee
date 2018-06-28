class Sapwood.ViewSorter

  @init: ->
    new Sapwood.ViewSorter(el) for el in $('[data-view-sorter]')

  constructor: (el) ->
    @el = $(el)
    @url = @el.data('view-sorter')
    @initSortable()

  initSortable: ->
    viewSorter = @
    @el.sortable(
      update: (event, ui) ->
        ids = $(this).sortable('toArray', { attribute: 'data-id' }).join(',')
        $.post(viewSorter.url, { view_ids: ids }, (data) ->
          if (data.success == true)
            # TODO: Render success message
          else
            # TODO: Render error message
        )
    )

$(document).ready(Sapwood.ViewSorter.init)
