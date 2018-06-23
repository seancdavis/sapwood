require 'rails_helper'

feature 'Elements Search', js: true do

  let(:property) { property_with_templates }
  let(:element) { create(:element, property: property, template_data: { name: 'Hello World' }) }

  background do
    element
    sign_in (@user = create(:admin))
    click_link property.title
    click_link 'Defaults'
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
    expect(page).to have_css('td.primary', text: 'Hello World')
    # The template name is also listed.
    expect(page).to have_css('td', text: 'Default')
    # The form value is still filled in.
    expect(page).to have_css("input#search_q[value='hello']")
  end

end
