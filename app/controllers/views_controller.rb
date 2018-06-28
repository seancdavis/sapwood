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

  # TODO: Move this to a service? To reorder something based on a
  # comma-delimited id list?

  def reorder
    not_found unless request.xhr? && params[:view_ids]
    view_ids = params[:view_ids].split(',').map(&:to_i)
    views = current_property.views.where(id: view_ids)
    view_ids.each_with_index do |id, idx|
      view = views.select { |v| v.id == id }.first
      view.update_columns(nav_position: idx) if view
    end
    render json: { success: true }
  rescue
    render json: { success: false }
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
