# frozen_string_literal: true

require 'rails_helper'

feature 'Property Settings', js: true do

  background do
    @property = property_with_templates
    @user = create(:user)
    @user.properties << @property
    sign_in @user
    click_link @property.title
  end

  scenario 'toggles a namespace' do
    expect(page).to have_no_content('Child')
    click_link 'Parent'
    expect(page).to have_content('Child')
    click_link 'Parent'
    expect(page).to have_no_content('Child')

    click_link 'Parent'
    click_link 'Child'
    visit current_path
    # Show that the menu is open when we land on that page
    within('aside') do
      expect(page).to have_content('Child')
    end
  end

  scenario 'does not show hidden templates' do
    expect(@property.find_template('Hidden')).to_not eq(nil)
    within('aside') do
      expect(page).to have_no_content('Hidden')
    end
  end

end
