require 'rails_helper'

feature 'Keys List', js: true do

  let(:property) { property_with_templates }
  let(:user) { create(:admin) }

  let(:key) { create(:key, property: property) }

  before(:each) do
    user.properties << property
    sign_in user
    click_link property.title
    first('.icon-settings').click
    within('.dropdown') { click_link('API Keys') }
  end

  scenario 'it supports a zero state' do
    expect(page).to have_content('Nothing here!')
  end

  scenario 'it shows a list of keys' do
    key && visit(current_path)
    expect(page).to have_content(key.title)
    # The value of the key (sensitive) is not rendered to the page.
    expect(page).to have_no_content(key.value)
  end

end
