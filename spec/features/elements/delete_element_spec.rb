require 'rails_helper'

feature 'Elements', :js => true do

  scenario 'can be deleted' do
    property = property_with_templates
    @user = create(:admin)
    element = create(:element, :property => property)
    sign_in @user
    visit property_template_elements_path(property, 'default')
    expect(page).to have_content(element.title)
    click_link element.title
    click_link 'Delete Default'
    expect(page).to have_no_content(element.title)
  end

end
