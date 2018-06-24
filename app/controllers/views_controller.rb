class ViewsController < ApplicationController

  def show
    not_found if current_view.blank?
    @elements = SearchElementsService.call(property: current_property, q: current_view.q)
    @elements = Kaminari.paginate_array(@elements).page(params[:page] || 1).per(20)
    render 'elements/search'
  end

end
