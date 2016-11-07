class App.Components.Search extends Backbone.View

  el: 'aside.main'

  noResults: JST['templates/no_search_results']
  results: JST['templates/search_result']

  container: $('.search .results')

  initialize: ->
    return true unless $('input#search').length > 0
    $('input#search').on('keyup', _.debounce(@search, 200))

  search: (e) =>
    q = $(e.target).val()
    unless q.length > 2
      @container.html('')
      return
    url = "#{$(e.target).data('url')}?q=#{q}"
    $.get(url, (results) =>
      if results.length > 0
        @container.html('')
        @container.append(@results(element: result)) for result in results
      else
        @container.html(@noResults)
    )
