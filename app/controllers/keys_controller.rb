class KeysController < ApplicationController

  before_action :verify_property_access

  def index
    @keys = current_property.keys.order(:title)
  end

  private

  def verify_property_access
    super
    not_found unless is_property_admin?
  end

end
