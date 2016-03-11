class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_filter :verify_installation
  before_filter :authenticate_user!, :except => [:auth]

  helper_method :current_collection,
                :current_document,
                :current_element,
                :current_element?,
                :current_property,
                :current_property?,
                :current_template,
                :focused_user,
                :not_found,
                :my_properties,
                :visible_property_users

  def home
    redirect_to deck_path
  end

  def auth
    user = User.find_by_id(params[:id])
    not_found if user.nil? || (user.sign_in_key != params[:key])
    user.delete_sign_in_key!
    sign_in_and_redirect user
  end

  private

    # ------------------------------------------ Checks

    def verify_installation
      redirect_to install_path(1) unless Sapwood.installed?
    end

    def verify_property_access
      not_found if current_property.nil?
      not_found unless current_user.has_access_to?(current_property)
    end

    # ------------------------------------------ Errors

    def not_found
      raise ActionController::RoutingError.new('Not found.')
    end

    # ------------------------------------------ Properties

    def my_properties
      @my_properties ||= current_user.accessible_properties.sort_by(&:title)
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

    # ------------------------------------------ Users

    def visible_property_users
      @visible_property_users ||= begin
        users = if current_user.is_admin?
          current_property.users_with_access
        else
          current_property.users
        end
        users.sort_by { |u| u.p.name }
      end
    end

    def focused_user
      @focused_user ||= begin
        p = params[:user_id] || params[:id]
        visible_property_users.select { |u| u.id.to_i == p.to_i }.first
      end
    end

end
