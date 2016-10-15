require 'rails_helper'

feature 'User', :js => true do

  scenario 'can edit a document name (a custom field)' do
    add_test_config
    @property = property_with_templates
    @document = create(:element, :document, :property => @property)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Images'
    click_link @document.title
    new_title = Faker::Book.title
    fill_in 'element[template_data][name]', :with => new_title
    click_button "Save Image"
    expect(page).to have_content(new_title)
  end

end
