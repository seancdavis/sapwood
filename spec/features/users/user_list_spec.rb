require 'rails_helper'

feature 'User List', :js => true do

  context 'as an admin' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @user_01 = create(:user)
      @user_02 = create(:user)
      @user_02.properties << @property
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
    end
    scenario 'does not contain users that do not have access' do
      expect(page).to_not have_content(@user_01.p.name)
    end
    scenario 'contains users that have access' do
      expect(page).to have_content(@user_02.p.name)
    end
    scenario 'contains admins' do
      expect(page).to have_content(@admin.p.name)
    end
  end

  context 'as a regular user' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @user_01 = create(:user)
      @user_02 = create(:user)
      @user_02.properties << @property
      @admin = create(:admin)
      sign_in @user_02
      click_link @property.title
      click_link 'Users'
    end
    scenario 'does not contain users that do not have access' do
      expect(page).to_not have_content(@user_01.p.name)
    end
    scenario 'contains users that have access' do
      expect(page).to have_content(@user_02.p.name)
    end
    scenario 'does not contain admins' do
      expect(page).to_not have_content(@admin.p.name)
    end
  end

end
