# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  name                   :string
#  sign_in_key            :string
#

class UsersController < ApplicationController

  before_filter :verify_property_access

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
                    :notice => 'User added successfully!'
      else
        @properties = Property.alpha.to_a - [current_property]
        render 'new'
      end
    else
      focused_user.properties << current_property
      redirect_to property_users_path(current_property),
                  :notice => 'User added successfully!'
    end
  end

  def edit
    verify_user_access
    @properties = Property.alpha
  end

  def update
    if focused_user.update(user_params)
      unless focused_user.is_admin?
        ids = if params[:user][:access]
          params[:user][:access].keys.collect(&:to_i)
        else
          []
        end
        focused_user.set_properties!(ids)
      end
      redirect_to property_users_path(current_property),
                  :notice => 'User updated successfully!'
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
      user_params.merge(:password => SecureRandom.hex(32))
    end

    def verify_user_access
      not_found if focused_user.nil?
      not_found if focused_user.is_admin? && !current_user.is_admin?
    end

end
