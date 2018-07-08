# frozen_string_literal: true

require 'rails_helper'

feature 'Attachments Search', js: true do

  let(:property) { property_with_templates }
  let(:attachment) { create(:attachment, property: property, title: 'Hello World') }

  let(:user) { user = create(:user); user.properties << property; user }

  background do
    attachment
    sign_in(user)
    click_link property.title
    first('.icon-arrow-down-circle').trigger('click')
    click_link 'Attachments'
  end

  scenario 'returns results in a list' do
    # Checking that heading changes, indicating we've moved location.
    expect(page).to have_no_css('h1', text: 'Search Results')
    # Fill out search form.
    within('form.search') do
      fill_in 'search[q]', with: 'hello'
      first('#search_q').native.send_keys(:enter)
    end
    # Now we should be on the right page.
    expect(page).to have_css('h1', text: 'Search Results')
    # The element is on the page.
    expect(page).to have_css('article.document', text: 'Hello World')
    # The form value is still filled in.
    expect(page).to have_css("input#search_q[value='hello']")
  end

end
