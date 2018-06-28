class ViewsController < ApplicationController

  before_action :verify_current_property
  before_action :verify_current_view, only: %i[edit update destroy]

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

  def edit
    @view = current_view
  end

  def update
    if current_view.update(view_params)
      redirect_to [current_property, current_view], notice: 'View updated successfully!'
    else
      render 'edit'
    end
  end

  def destroy
    current_view.destroy
    redirect_to [current_property, current_property.views.first], notice: 'View deleted successfully.'
  end

  private

    def verify_current_property
      not_found unless current_property
    end

    def verify_current_view
      not_found unless current_view
    end

    def view_params
      params.require(:view).permit(:title, :q)
    end

end
