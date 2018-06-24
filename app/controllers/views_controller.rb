class ViewsController < ApplicationController

  def show
    not_found if current_view.blank?
    @elements = SearchElementsService.call(property: current_property, q: current_view.q)
    render 'elements/search'
  end

end
