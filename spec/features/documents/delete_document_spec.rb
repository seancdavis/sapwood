require 'rails_helper'

feature 'User', js: true do

  scenario 'can be deleted' do
    property = property_with_templates
    @user = create(:admin)
    element = create(:element, :document, property: property)
    sign_in @user
    visit property_template_documents_path(property, 'image')
    expect(page).to have_content(element.title)
    click_link element.title
    click_link 'Delete Image'
    expect(page).to have_no_content(element.title)
    # Just in case we had been redirected to the wrong path.
    visit property_template_documents_path(property, 'image')
    expect(page).to have_no_content(element.title)
  end

end
