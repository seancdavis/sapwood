class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    @user.set_sign_in_key!
    @user.reload
    mail :to => @user.email, :from => Sapwood.config.default_from,
         :subject => 'Welcome to Sapwood!'
  end

end
