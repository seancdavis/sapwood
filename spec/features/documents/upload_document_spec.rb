require 'rails_helper'

feature 'User', :js => true do

  background do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @property = create(:property, :templates_raw => File.read(file))
    @document = build(:document)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Documents'
  end

  scenario 'can upload documents' do
    upload_image
    wait_for_ajax
    visit current_path
    screenshot_and_open_image
    expect(page).to have_content('Example')
  end

end
