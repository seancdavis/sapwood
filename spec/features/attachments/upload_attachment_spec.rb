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

  scenario 'can upload an attachment' do
    visit_attachments
    # Zero state
    expect(page).to have_no_content('Uploaded successfully!')
    expect(page).to have_no_css('span.title', text: 'Example')
    # Upload
    page.execute_script("$('#fileupload').toggle();")
    attach_file 'file', ["#{Rails.root}/spec/support/example.png"]
    wait_for_ajax
    # After upload success
    expect(page).to have_content('Uploaded successfully!')
    expect(page).to have_no_css('span.title', text: 'Example')
    # Reload page
    visit current_path
    expect(page).to have_css('span.title', text: 'Example')
  end

end
