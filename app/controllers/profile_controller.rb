class ProfileController < ApplicationController

  def edit
  end

  def update
    if current_user.update(profile_params)
      if changing_password?
        sign_in(current_user, :bypass => true)
      end
      redirect_to edit_profile_path, :notice => 'Profile updated successfully!'
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

end
