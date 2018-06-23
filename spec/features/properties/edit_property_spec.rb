require 'rails_helper'

feature 'Property', js: true do

  background do
    @property = create(:property)
  end

  context 'as an admin' do
    background do
      @user = create(:admin)
      sign_in @user
      click_link @property.title
      within('aside') { first('.dropdown a.trigger').click }
    end

    scenario 'enable a user to update the title' do
      within('aside') { click_link('General') }
      new_title = Faker::Lorem.words(5).join(' ')
      fill_in 'property[title]', with: new_title
      click_button 'Save Changes'
      expect(page).to have_css('aside span.title', text: new_title)
    end

    scenario 'can edit data configuration' do
      within('aside') { click_link('Data Config') }
      first('.CodeMirror').send_keys('[{"title": "Template 1"}]')
      click_button 'Save Changes'
      expect(page).to have_css('aside li', text: 'Template 1')
    end
  end

  context 'as a regular user' do
    scenario 'can not see link to any of the settings' do
      @user = create(:user)
      @user.properties << @property
      sign_in @user
      click_link @property.title
      expect(page).to have_no_css('.dropdown a.trigger')
    end
  end

end
