class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_filter :verify_installation

  helper_method :not_found

  def home
  end

  private

    def verify_installation
      redirect_to install_path(1) unless Sapwood.installed?
    end

    # ------------------------------------------ Errors

    def not_found
      raise ActionController::RoutingError.new('Not found.')
    end

end
