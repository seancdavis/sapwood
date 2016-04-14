class InstallController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_profile_completion

  def show
    if params[:step].blank?
      redirect_to install_path(:step => 'welcome')
    else
      render params[:step]
    end
  end

  def update
    if params[:step] == 'user'
      user = User.new(user_params)
      if user.save
        redirect_to install_path('finish')
      else
        render 'user'
      end
    elsif params[:step] == 'finish'
      Sapwood.set('installed?', true)
      Sapwood.write!
      sign_in_and_redirect User.first
    end
  end

  private

    def verify_installation
      redirect_to root_path if Sapwood.installed?
    end

    def user_params
      params
        .require(:install)
        .permit(:name, :email, :password, :password_confirmation)
        .merge(:is_admin => true)
    end

end
