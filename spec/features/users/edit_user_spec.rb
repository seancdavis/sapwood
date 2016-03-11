require 'rails_helper'

feature 'Users', :js => true do

  context 'as an admin' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @user = create(:user)
      @user.properties << @property
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
    end
    scenario 'can have their name changed' do
      click_link @user.name
      name = Faker::Name.name
      fill_in 'user[name]', :with => name
      click_button 'Save'
      expect(page).to have_content(name)
    end
  end

end
