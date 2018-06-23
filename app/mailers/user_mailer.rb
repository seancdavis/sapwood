# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    @user.set_sign_in_key!
    @user.reload
    mail to: @user.email, from: ENV['DEFAULT_FROM_EMAIL'],
         subject: 'Welcome to Sapwood!'
  end

end
