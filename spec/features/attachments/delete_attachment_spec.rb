# frozen_string_literal: true

require 'rails_helper'

feature 'Attachments', js: true do

  let(:property) { create(:property) }

  let(:user) do
    user = create(:user)
    user.properties << property
    user
  end

  let(:visit_attachments) do
    sign_in(user)
    visit property_attachments_path(property)
  end

  scenario 'can delete an attachment' do
    create(:attachment, property: property, title: 'Hello World')
    visit_attachments
    expect(page).to have_css('span.title', text: 'Hello World')
    click_link 'Hello World'
    click_link 'Delete Attachment'
    expect(page).to have_no_css('span.title', text: 'Hello World')
  end

end
