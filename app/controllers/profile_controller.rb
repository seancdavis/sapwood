class ProfileController < ApplicationController

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to edit_profile_path, :notice => 'Profile updated successfully!'
    else
      render 'edit'
    end
  end

  private

    def profile_params
      params.require(:user).permit(:name)
    end

end
