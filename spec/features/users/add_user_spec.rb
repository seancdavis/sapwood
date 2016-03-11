require 'rails_helper'

feature 'Users', :js => true do

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
    scenario 'can be added to the property' do
      email = Faker::Internet.email
      fill_in 'user[email]', :with => email
      click_button 'Save'
      expect(page).to have_content(email)
    end
    scenario 'will add an existing user with just an email' do
      user = create(:user)
      fill_in 'user[email]', :with => user.email
      click_button 'Save'
      expect(page).to have_content(user.name)
    end
    scenario 'can make a new user an admin' do
      fill_in 'user[email]', :with => Faker::Internet.email
      first("label[for='user_is_admin']").click
      click_button 'Save'
      expect(User.order(:id => :desc).first.is_admin).to eq(true)
    end
  end

end
