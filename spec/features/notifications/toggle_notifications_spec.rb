# frozen_string_literal: true

require 'rails_helper'

feature 'Notifications', js: true do

  scenario 'can be toggled for any template' do
    @property = property_with_templates
    @user_01 = create(:admin)
    sign_in @user_01
    click_link @property.title

    # Turn on for Default
    click_link 'Defaults'
    expect(Notification.count).to eq(0)
    expect(page).to have_css('a.notification-toggle')
    expect(page).to have_no_css('a.notification-toggle.on')
    first('a.notification-toggle').click
    expect(page).to have_css('a.notification-toggle.on')
    expect(Notification.count).to eq(1)

    # Check a different template
    click_link 'All Options'
    expect(page).to have_css('a.notification-toggle')
    expect(page).to have_no_css('a.notification-toggle.on')

    # Try a different user
    click_link 'Sign Out'
    @user_02 = create(:admin)
    sign_in @user_02
    click_link @property.title
    click_link 'Defaults'
    expect(Notification.count).to eq(1)
    expect(page).to have_css('a.notification-toggle')
    expect(page).to have_no_css('a.notification-toggle.on')
    first('a.notification-toggle').click
    expect(page).to have_css('a.notification-toggle.on')
    expect(Notification.count).to eq(2)
  end

end
