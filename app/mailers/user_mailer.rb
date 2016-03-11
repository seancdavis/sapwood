class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
  end

end
