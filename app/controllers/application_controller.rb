class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_filter :verify_installation
  before_filter :authenticate_user!

  helper_method :current_property,
                :current_property?,
                :not_found,
                :my_properties

  def home
    redirect_to deck_path
  end

  private

    def verify_installation
      redirect_to install_path(1) unless Sapwood.installed?
    end

    # ------------------------------------------ Errors

    def not_found
      raise ActionController::RoutingError.new('Not found.')
    end

    # ------------------------------------------ Properties

    def my_properties
      @my_properties ||= Property.alpha
    end

    def current_property
      @current_property ||= begin
        Property.find_by_id(params[:property_id] || params[:id])
      end
    end

    def current_property?
      current_property && current_property.id.present?
    end

end
