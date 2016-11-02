class ProfileController < ApplicationController

  skip_before_filter :verify_profile_completion

  def edit
  end

  def update
    if current_user.update(profile_params)
      if changing_password?
        sign_in(current_user, :bypass => true)
      end
      redirect_to redirect_path, :notice => 'Profile updated successfully!'
    else
      render 'edit'
    end
  end

  private

    def profile_params
      params.require(:user).permit(:name, :password, :password_confirmation)
            .reject { |k,v| v.blank? }
    end

    def changing_password?
      profile_params.include?(:password) &&
      profile_params.include?(:password_confirmation)
    end

    def redirect_path
      return deck_path unless current_property
      edit_profile_path(:property_id => params[:property_id])
    end

end
