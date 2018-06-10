# frozen_string_literal: true

class ApiController < ActionController::Base
  before_action :allow_cors
  before_action :authenticate_api_user!, except: [:options]

  caches_action :index, cache_path: :index_cache_path.to_proc
  caches_action :show, cache_path: :show_cache_path.to_proc

  helper_method :current_property

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
