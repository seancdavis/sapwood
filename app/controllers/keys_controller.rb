class KeysController < ApplicationController

  before_action :verify_property_access

  def index
  end

  private

  def verify_property_access
    super
    not_found unless is_property_admin?
  end

end
