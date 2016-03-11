require 'rails_helper'

feature 'Users', :js => true do

  context 'ad an admin' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
    end
    scenario 'can be added to the property' do
      click_link 'New User'
      email = Faker::Internet.email
      fill_in 'user[email]', :with => email
      click_button 'Save'
      expect(page).to have_content(email)
    end
  end

end
