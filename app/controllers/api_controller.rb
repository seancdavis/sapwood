class ApiController < ActionController::Base

  before_filter :allow_cors
  before_filter :authenticate_api_user!

  helper_method :current_property

  private

    def forbidden
      raise ActionController::RoutingError.new('Forbidden')
    end

    def not_found
      raise ActionController::RoutingError.new('Not found.')
    end

    def authenticate_api_user!
      forbidden unless current_property.present?
    end

    def current_property
      @current_property ||= Property.find_by_api_key(params[:api_key])
    end

    def allow_cors
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

end
