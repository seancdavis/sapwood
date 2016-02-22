require 'rails_helper'

feature 'Elements', :js => true do

  background do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @property = create(:property, :templates_raw => File.read(file))
    @element = build(:element)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Elements'
    click_link 'New'
    click_link 'Default'
  end

  scenario 'can be created by a user with the basics' do
    fill_in 'element[title]', :with => @element.title
    click_button 'Save Default'
    expect(page).to have_content(@element.title)
  end

  scenario 'will save custom fields' do
    fill_in 'element[title]', :with => @element.title
    subtitle = Faker::Lorem.sentence
    fill_in 'element[template_data][subtitle]', :with => subtitle
    click_button 'Save Default'
    expect(Element.find_by_title(@element.title).subtitle).to eq(subtitle)
  end

end
