require 'rails_helper'

feature 'Users', :js => true do

  context 'as an admin' do
    background do
      @properties = create_list(:property, 3)
      @property = @properties.first
      @element = build(:element)
      @user = create(:user)
      @user.properties << @property
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
      click_link @user.name
    end
    scenario 'can be assigned to a property' do
      first("label[for='access-#{@properties.last.id}']").click
      click_button 'Save'
      expect(@user.has_access_to?(@properties.last)).to eq(true)
    end
    scenario 'shows the properties when user is not set to admin' do
      expect(page).to have_content(@properties.last.title)
    end
    scenario 'does not show admin message when not set to admin' do
      expect(page).to_not have_content('Admin users have access to all')
    end
    scenario 'does not show the properties when user is not set to admin' do
      first("label[for='user_is_admin']").click
      expect(page).to_not have_content(@properties.last.title)
    end
    scenario 'shows admin message when not set to admin' do
      first("label[for='user_is_admin']").click
      expect(page).to have_content('Admin users have access to all')
    end
  end

end
