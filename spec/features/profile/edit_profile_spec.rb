# frozen_string_literal: true

require 'rails_helper'

feature 'My Profile', js: true do

  background do
    @property = create(:property)
    @user = create(:user)
    @user.properties << @property
    sign_in @user
  end

  scenario 'does not have a link when not within a property' do
    # Need two properties to not be within a property
    @user.properties << create(:property)
    visit deck_path
    expect(page).to have_no_content('Profile')
  end

  scenario 'lets me change my name' do
    click_link @property.title
    within('header.main') { click_link('Profile') }
    fill_in 'user[name]', with: (name = Faker::Name.name)
    click_button 'Save'
    within('header.main') { expect(page).to have_content(name) }
  end

  scenario 'maintains the property sidebar' do
    within('aside.main') { expect(page).to have_content(@property.title) }
  end

  scenario 'shows only the list of properties I can access' do
    property = create(:property)
    click_link @property.title
    within('header.main') { click_link('Profile') }
    within('form') do
      expect(page).to have_content(@property.title)
      expect(page).to have_no_content(property.title)
    end
  end

end
