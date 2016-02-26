require 'rails_helper'

feature 'User', :js => true do

  background do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @property = create(:property, :templates_raw => File.read(file))
    @document = create(:document, :property => @property)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Documents'
    click_link @document.title
  end

  scenario 'can edit a document title' do
    new_title = Faker::Book.title
    fill_in 'document[title]', :with => new_title
    click_button "Save Example"
    expect(page).to have_content(new_title)
  end

end
