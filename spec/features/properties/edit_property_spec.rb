require 'rails_helper'

feature 'Property Settings', :js => true do

  background do
    @property = create(:property)
    @user = create(:admin)
    sign_in @user
  end

  scenario 'enable a user to update the title' do
    within('.properties') { click_link 'Edit' }
    # Check that the API key is visible.
    expect(page).to have_content(@property.api_key)
    # Fill in the title and submit.
    new_title = Faker::Lorem.words(5).join(' ')
    fill_in 'property[title]', :with => new_title
    click_button 'Save Changes'
    expect(page).to have_content(new_title)
  end

end
