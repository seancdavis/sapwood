class ViewsController < ApplicationController

  before_action :verify_current_property

  def new
    @view = current_property.views.new(q: params[:q])
  end

  def create
    @view = current_property.views.new(view_params)
    if @view.save
      redirect_to [current_property, @view], notice: 'View created successfully!'
    else
      render 'new'
    end
  end

  def show
    not_found if current_view.blank?
    @elements = SearchElementsService.call(property: current_property, q: current_view.q)
    @elements = Kaminari.paginate_array(@elements).page(params[:page] || 1).per(20)
    render 'elements/search'
  end

  private

    def verify_current_property
      not_found unless current_property
    end

    def view_params
      params.require(:view).permit(:title, :q)
    end

end
