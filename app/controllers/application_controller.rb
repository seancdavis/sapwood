class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_filter :verify_installation
  before_filter :authenticate_user!

  helper_method :current_collection,
                :current_document,
                :current_element,
                :current_element?,
                :current_property,
                :current_property?,
                :current_template,
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

    # ------------------------------------------ Templates

    def current_template
      @current_template ||= begin
        return current_element.template if current_element.template
        current_property.find_template(params[:template]) if params[:template]
      end
    end

    # ------------------------------------------ Elements

    def current_element
      @current_element ||= begin
        current_property.elements.find_by_id(params[:element_id] || params[:id])
      end
    end

    def current_element?
      current_element && current_element.id.present?
    end

    # ------------------------------------------ Documents

    def current_document
      @current_document ||= begin
        id = params[:document_id] || params[:id]
        current_property.documents.find_by_id(id)
      end
    end

    # ------------------------------------------ Collections

    def current_collection
      @current_collection ||= begin
        id = params[:collection_id] || params[:id]
        current_property.collections.find_by_id(id)
      end
    end

end
