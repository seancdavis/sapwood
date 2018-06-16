# frozen_string_literal: true

require 'rails_helper'

feature 'Create API Key', js: true do

  let(:property) { property_with_templates }
  let(:user) { create(:admin) }

  before(:each) do
    user.properties << property
    sign_in user
    click_link property.title
    first('.icon-settings').click
    within('.dropdown') { click_link('API Keys') }
    click_link 'New API Key'
  end

  scenario 'create a readable key' do
    fill_in 'Title', with: 'My First Key'
    click_button 'Save Key'
    # Redirects to the show page.
    expect(page).to have_css('h1', text: 'My First Key')
    # Check database just to be sure.
    key = Key.first
    expect(key.title).to eq('My First Key')
    expect(key.readable?).to eq(true)
  end

  scenario 'create a writeable key' do
    fill_in 'Title', with: 'My First Key'
    first('#key_writeable').set(true)
    select 'Default', from: 'key_template_selector'
    click_button 'Save Key'
    key = Key.first
    # Redirects to the show page.
    expect(page).to have_css('h1', text: 'My First Key')
    expect(page).to have_css('p', text: key.value)
    # Check database just to be sure.
    expect(key.title).to eq('My First Key')
    expect(key.writeable?).to eq(true)
    expect(key.template_names).to match_array(['Default'])
  end

end
