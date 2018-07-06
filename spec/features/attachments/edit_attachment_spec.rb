# frozen_string_literal: true

require 'rails_helper'

feature 'Attachments', js: true do

  let(:property) { create(:property) }
  let(:attachment) { create(:attachment, property: property) }

  let(:user) do
    user = create(:user)
    user.properties << property
    user
  end

  let(:visit_attachments) do
    sign_in(user)
    visit property_attachments_path(property)
  end

  scenario 'can edit the title' do
    attachment
    visit_attachments
    expect(page).to have_no_css('span.title', text: 'Hello World')
    click_link attachment.title
    fill_in 'attachment[title]', with: 'Hello World'
    click_button 'Save Attachment'
    expect(page).to have_css('span.title', text: 'Hello World')
  end

end
