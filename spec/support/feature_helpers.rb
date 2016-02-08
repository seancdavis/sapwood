module FeatureHelpers

  def sign_in(user, password = 'password')
    visit root_path
    fill_in 'user[email]', :with => user.email
    fill_in 'user[password]', :with => password
    click_button 'Sign In'
  end

  def sign_out
    page.find('#sign-out').click
  end

end
