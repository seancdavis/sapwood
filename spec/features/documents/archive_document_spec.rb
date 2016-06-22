require 'rails_helper'

feature 'User', :js => true do

  scenario 'can archive a document' do
    add_test_config
    @property = property_with_templates
    @document = create(:document, :property => @property)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Documents'
    expect(page).to have_css('article.document')
    click_link @document.title
    click_link 'Archive Document'
    expect(page).to have_content("#{@document.title} archived successfully!")
    expect(page).to have_no_css('article.document')
  end

end
