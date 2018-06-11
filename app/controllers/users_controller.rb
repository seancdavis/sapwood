# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :verify_property_access
  before_action :verify_property_admin_access

  def index
  end

  def new
    @properties = Property.alpha.to_a - [current_property]
    @focused_user = User.new
  end

  def create
    @focused_user = User.find_by_email(params[:user][:email])
    if focused_user.nil?
      if @focused_user = User.create(user_params_with_password)
        UserMailer.welcome(focused_user).deliver_now
        focused_user.properties << current_property unless focused_user.is_admin?
        redirect_to property_users_path(current_property),
                    notice: 'User added successfully!'
      else
        @properties = Property.alpha.to_a - [current_property]
        render 'new'
      end
    else
      focused_user.properties << current_property
      redirect_to property_users_path(current_property),
                  notice: 'User added successfully!'
    end
  end

  def edit
    not_found unless can_edit_focused_user?
    @properties = Property.alpha
  end

  def update
    not_found unless can_edit_focused_user?
    if focused_user.update(user_params)
      unless focused_user.is_admin?
        access_ids = if params[:user][:access].blank?
          []
        else
          editor_ids = if params[:user][:access][:editor].present?
            params[:user][:access][:editor].keys.collect(&:to_i)
          else
            []
          end
          admin_ids = if params[:user][:access][:admin].present?
            params[:user][:access][:admin].keys.collect(&:to_i)
          else
            []
          end
          (editor_ids + admin_ids).uniq.sort
        end
        focused_user.set_properties!(access_ids)
        focused_user.make_admin_in_properties!(admin_ids)
      end
      redirect_to property_users_path(current_property),
                  notice: 'User updated successfully!'
    else
      @properties = Property.alpha
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :is_admin)
    end

    def user_params_with_password
      user_params.merge(password: SecureRandom.hex(32))
    end

    def verify_property_admin_access
      not_found unless is_property_admin?
    end

    def can_edit_focused_user?
      return false if focused_user.blank?
      return true if current_user.is_admin?
      !focused_user.is_admin?
    end
end
