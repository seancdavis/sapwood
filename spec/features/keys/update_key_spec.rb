# frozen_string_literal: true

require 'rails_helper'

feature 'Update API Key', js: true do

  let(:property) { property_with_templates }
  let(:user) { create(:admin) }

  before(:each) do
    user.properties << property
    sign_in user
    click_link property.title
    first('.icon-settings').click
    within('.dropdown') { click_link('API Keys') }
  end

  scenario 'update a readable key' do
    key = create(:key, property: property)
    title = 'Yet Another Key'
    expect(Key.first.title).to_not eq(title)
    visit(current_path)
    # Change the name
    click_link key.title
    fill_in 'Title', with: title
    click_button 'Save Key'
    # Redirects to the show page.
    expect(page).to have_css('h1', text: title)
    # Check database just to be sure.
    key = Key.first
    expect(key.title).to eq(title)
  end

  scenario 'undoing writeable removes template_names' do
    key = create(:key, property: property, writeable: true, template_names: ['Default'])
    expect(Key.first.template_names).to match_array(['Default'])
    visit(current_path)
    click_link key.title
    first('#key_writeable').set(false)
    click_button 'Save Key'
    expect(Key.first.template_names.blank?).to eq(true)
  end

end
