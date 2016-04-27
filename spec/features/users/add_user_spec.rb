require 'rails_helper'

feature 'New Users', :js => true do

  context 'as an admin' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
      click_link 'New User'
    end
    scenario 'can not be given a name' do
      expect(page).to_not have_css('#user_name')
    end
    scenario 'can make a new user an admin' do
      fill_in 'user[email]', :with => Faker::Internet.email
      first("label[for='user_is_admin']").click
      click_button 'Save'
      expect(User.order(:id => :desc).first.is_admin).to eq(true)
    end
  end

end
