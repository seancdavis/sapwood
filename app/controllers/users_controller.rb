class UsersController < ApplicationController

  before_filter :verify_property_access

  def index
  end

  def new
    @focused_user = User.new
  end

  def create
    @focused_user = User.find_by_email(params[:user][:email])
    if focused_user.nil?
      if @focused_user = User.create(user_params.merge(:password => 'password'))
        focused_user.properties << current_property unless focused_user.is_admin?
        redirect_to property_users_path(current_property),
                    :notice => 'User added successfully!'
      else
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
  end

  def update
    # focused_user = User.find_by_id(params[:id])
    if focused_user.update(user_params)
      unless focused_user.is_admin?
        focused_user.set_properties!(params[:user][:access].keys.collect(&:to_i))
      end
      redirect_to property_users_path(current_property),
                  :notice => 'User updated successfully!'
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :is_admin)
    end

    def verify_user_access
      not_found if focused_user.nil?
      not_found if focused_user.is_admin? && !current_user.is_admin?
    end

end
