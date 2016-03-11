class UsersController < ApplicationController

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user.nil?
      if @user = User.create(user_params.merge(:password => 'password'))
        @user.properties << current_property unless @user.is_admin?
        redirect_to property_users_path(current_property),
                    :notice => 'User added successfully!'
      else
        render 'new'
      end
    else
      @user.properties << current_property
      redirect_to property_users_path(current_property),
                  :notice => 'User added successfully!'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :is_admin)
    end

end
