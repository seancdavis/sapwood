# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:auth]
  before_action :verify_profile_completion, except: [:auth]

  helper_method :is_property_admin?,
                :current_document,
                :current_element,
                :current_element?,
                :current_property,
                :current_property?,
                :current_property_documents,
                :current_template,
                :focused_user,
                :not_found,
                :my_properties,
                :visible_property_users

  def home
    redirect_to deck_path
  end

  def auth
    if user_signed_in?
      redirect_to root_path
    else
      user = User.find_by_id(params[:user_id])
      if (
        user.nil? ||
        (user.sign_in_id != params[:id]) ||
        (user.sign_in_key != params[:key])
      )
        not_found
      end
      user.delete_sign_in_key!
      sign_in_and_redirect user
    end
  end

  private

    # ------------------------------------------ Checks

    def verify_property_access
      not_found if current_property.nil?
      not_found unless current_user.has_access_to?(current_property)
    end

    def verify_profile_completion
      if (user_signed_in? &&
         controller_name != 'sessions' &&
         current_user.name.blank?)
        redirect_to edit_profile_path(setup: true),
                    alert: 'You need to complete your profile.'
      end
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

    def is_property_admin?
      @is_property_admin ||= current_user.is_admin_of?(current_property)
    end

    # ------------------------------------------ Templates

    def current_template
      @current_template ||= current_property.find_template(params[:template_id])
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

    def current_property_documents
      @current_property_documents ||= current_property.documents.alpha
    end

    # ------------------------------------------ Users

    def visible_property_users
      @visible_property_users ||= begin
        users = if current_user.is_admin?
          current_property.users_with_access
        else
          current_property.users - User.admins
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
