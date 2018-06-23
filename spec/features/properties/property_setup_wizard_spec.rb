require 'rails_helper'

feature 'Property Setup Wizard' do

  background do
    @property = build(:property)
    @user = create(:admin)
    sign_in @user
  end

  scenario 'It can run through the entire process' do
    click_link 'New Property'
    fill_in 'Title', with: @property.title
    click_button 'Next'
    fill_in 'Color', with: @property.color
    click_button 'Next'
    fill_in 'property[templates_raw]', with: File.read(template_config_file)
    click_button 'Next'
    expect(page).to have_content('Go To Property')
    property = Property.first
    expect(property.title).to eq(@property.title)
    expect(property.color).to eq(@property.color)
    expect(JSON.parse(property.templates_raw))
      .to eq(JSON.parse(File.read(template_config_file)))
    within('aside') do
      expect(page).to have_content('Defaults')
      expect(page).to have_content('All Options')
      expect(page).to have_content('More Options')
    end
  end

end
