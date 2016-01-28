class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_filter :verify_installation

  def home
  end

  private

    def verify_installation
      redirect_to install_path(1) unless sapwood.installed?
    end

end
