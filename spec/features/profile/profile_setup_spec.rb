require 'rails_helper'

feature 'My Profile', :js => true do

  background do
    @user = create(:user, :name => nil)
    sign_in @user
  end
  scenario 'must be completed before I move on' do
    expect(page).to have_content('Add your name.')
    expect(page).to have_content('Set a password for your account.')
    expect(page).to have_content('You need to complete your profile.')
  end

end
