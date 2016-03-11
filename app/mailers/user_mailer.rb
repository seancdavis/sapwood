class UserMailer < ApplicationMailer

  default :from => Sapwood.config.default_from

  def welcome(user)
    @user = user
    @user.set_sign_in_key!
    @user.reload
    mail :to => @user.email, :subject => 'Welcome to Sapwood!'
  end

end
