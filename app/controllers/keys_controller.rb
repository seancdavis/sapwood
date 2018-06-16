class KeysController < ApplicationController

  before_action :verify_property_access
  before_action :set_key, only: %i[show edit update destroy]


  def index
    @keys = current_property.keys.order(:title)
  end

  def new
    @key = Key.new
  end

  def create
    @key = Key.new(key_params.merge(property: current_property))
    @key.generate_value!
    if @key.save
      redirect_to [:edit, current_property, @key], notice: 'Key created successfully!'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @key.update(key_params)
      redirect_to [:edit, current_property, @key], notice: 'Key updated successfully!'
    else
      render 'edit'
    end
  end

  def destroy
    @key.destroy
    redirect_to [current_property, :keys], notice: 'Key deleted successfully!'
  end

  private

  def set_key
    @key = current_property.keys.find_by(id: params[:id])
    not_found if @key.blank?
  end

  def key_params
    template_names = params[:key][:writeable].to_bool ? params[:key][:template_names].split(',') : []
    params.require(:key).permit(:title, :writeable).merge(template_names: template_names)
  end

  def verify_property_access
    super
    not_found unless is_property_admin?
  end

end
