require 'rails_helper'

feature 'An admin', :js => true do

  context 'when editing a property user' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @user = create(:user)
      @user.properties << @property
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
      click_link @user.name
    end
    scenario 'can not change their name' do
      expect(page).to have_selector('#user_name[disabled]', :count => 1)
    end
    scenario 'can not change their email' do
      expect(page).to have_selector('#user_email[disabled]', :count => 1)
    end
  end

end
