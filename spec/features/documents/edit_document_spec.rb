require 'rails_helper'

feature 'User', :js => true do

  background do
    @property = property_with_template_file('private_docs')
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  scenario 'can edit a document name (a custom field) and shows URL' do
    document = create(:element, :document, :property => @property,
                      :template_name => 'Public')
    click_link 'Public'
    click_link document.title
    expect(page).to have_content(document.url)
    new_title = Faker::Book.title
    fill_in 'element[template_data][name]', :with => new_title
    click_button "Save Public"
    expect(page).to have_content(new_title)
  end

  scenario 'can edit a private document name, but shows no URL' do
    document = create(:element, :document, :property => @property,
                      :template_name => 'Private')
    click_link 'Private'
    click_link document.title
    expect(page).to have_no_content(document.url)
    expect(page).to have_content('[Private]')
    new_title = Faker::Book.title
    fill_in 'element[template_data][name]', :with => new_title
    click_button "Save Private"
    expect(page).to have_content(new_title)
  end

end
