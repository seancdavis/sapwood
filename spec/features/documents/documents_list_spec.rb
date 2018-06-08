require 'rails_helper'

feature 'Documents List', :js => true do

  background do
    @property = property_with_template_file('private_docs')
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'when there are no documents' do
    scenario 'displays a message when there are no documents' do
      click_link 'Public'
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are documents' do
    scenario 'does not display a message, but shows tiles' do
      create(:element, :document, :property => @property,
             :template_name => 'Public')
      click_link 'Public'
      expect(page).to have_no_content('Nothing here yet!')
      expect(page).to have_css('section.body article.document')
      expect(page).to have_no_css('section.body table')
    end
    scenario 'has a filter by title' do
      create(:element, :document, :property => @property,
             :template_name => 'Public', :template_data => {})
      click_link 'Public'
      expect(page).to have_content('178947853882959841 1454569459')
      click_link '0-9'
      expect(page).to have_content('178947853882959841 1454569459')
      click_link 'A'
      expect(page).to have_no_content('178947853882959841 1454569459')
    end
    scenario 'private docs has a table and not tiles' do
      create(:element, :document, :property => @property,
             :template_name => 'Private')
      click_link 'Private'
      expect(page).to have_no_content('Nothing here yet!')
      expect(page).to have_no_css('section.body article.document')
      expect(page).to have_css('section.body table')
    end
  end

end
