require 'rails_helper'

feature 'Property Settings' do

  background do
    @property = create(:property)
    @user = create(:admin)
    sign_in @user
  end

  scenario 'enable a user to update the title' do
    within('.properties') { click_link 'Edit' }
    new_title = Faker::Lorem.words(5).join(' ')
    fill_in 'Title', :with => new_title
    click_button 'Save Changes'
    expect(page).to have_content(new_title)
  end

end
