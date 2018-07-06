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

  scenario 'are accessible via main dropdown menu' do
    sign_in(user)
    click_link property.title
    first('.icon-arrow-down-circle').trigger('click')
    click_link 'Attachments'
    expect(page).to have_css('h1', text: 'Attachments')
    expect(current_path).to eq(property_attachments_path(property))
    # Zero state
    expect(page).to have_content('Nothing here!')
  end

  scenario 'contains paginated tiles, listed alphabetically' do
    ('a'..'z').to_a.each { |x| create(:attachment, property: property, title: x) }
    visit_attachments
    expect(first('article.document')).to have_css('span.title', text: 'a')
    ('a'..'x').to_a.each { |x| expect(page).to have_css('article.document', text: x) }
    ('y'..'z').to_a.each { |x| expect(page).to have_no_css('article.document', text: x) }
    click_link '2'
    ('a'..'x').to_a.each { |x| expect(page).to have_no_css('article.document', text: x) }
    ('y'..'z').to_a.each { |x| expect(page).to have_css('article.document', text: x) }
  end

end
