class KeysController < ApplicationController

  before_action :verify_property_access

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
      redirect_to [current_property, :keys], notice: 'Key created successfully!'
    else
      render 'new'
    end
  end

  private

  def key_params
    params.require(:key).permit(:title, :writeable, :template_names)
  end

  def verify_property_access
    super
    not_found unless is_property_admin?
  end

end
