class ApiController < ActionController::Base

  before_filter :authenticate_api_user!

  helper_method :current_property

  private

    def forbidden
      raise ActionController::RoutingError.new('Forbidden')
    end

    def authenticate_api_user!
      forbidden unless current_property.present?
      forbidden unless params[:api_key].present?
      forbidden unless params[:api_key] == current_property.api_key
    end

    def current_property
      @current_property ||= begin
        Property.find_by_id(params[:property_id] || params[:id])
      end
    end

end
