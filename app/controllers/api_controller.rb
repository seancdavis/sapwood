class ApiController < ActionController::Base

  before_action :allow_cors
  before_action :authenticate_api_user!, except: [:options]

  caches_action :index, cache_path: :index_cache_path.to_proc
  caches_action :show, cache_path: :show_cache_path.to_proc

  helper_method :current_property

  before_action :set_default_response_format

  def options
    render nothing: true
  end

  protected

    def index_cache_path
      "_p#{current_property.id}_#{controller_name}\#index#{q_to_s}"
    end

    def show_cache_path
      "_p#{current_property.id}_#{controller_name}\#show_#{params[:id]}#{q_to_s}"
    end

    def q_to_s
      q = ''
      request.query_parameters.each { |k, v| q += "_#{k}_#{v}" }
      q
    end

    private

      def set_default_response_format
        request.format = :json unless params[:format]
      end

      def forbidden
        raise ActionController::RoutingError.new('Forbidden')
      end

      def not_found
        raise ActionController::RoutingError.new('Not found.')
      end

      def authenticate_api_user!
        forbidden unless current_property.present?
      end

      def authenticate_writable_api_key!
        # Key must be readable and match current property.
        authenticate_api_user!
        # Key must be writable.
        forbidden unless current_api_key.writable?
        # Key must be able to write the template. (Currently all writable
        # requests require a template param.)
        forbidden unless current_api_key.template_names.include?(params[:template])
      end

      def current_api_key
        @current_api_key ||= begin
          return nil if params[:api_key].blank?
          Key.find_by_value(params[:api_key])
        end
      end

      def current_property
        @current_property ||= begin
          property = current_api_key.try(:property)
          current_property_id = (params[:property_id] || params[:id]).to_i
          property.present? && property.id == current_property_id ? property : nil
        end
      end

      def allow_cors
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

end
