require 'rails_helper'

feature 'Elements', :js => true do

  background do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @property = create(:property, :templates_raw => File.read(file))
    @element = create(:element, :property => @property)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Elements'
    click_link @element.title
  end

  scenario 'title can be updated' do
    new_title = Faker::Lorem.words(5).join(' ').titleize
    fill_in 'element[title]', :with => new_title
    click_button 'Save Default'
    expect(page).to have_content(new_title)
  end

  scenario 'has info on the sidebar' do
    expect(page).to have_content("ID: #{@element.id}")
    expect(page).to have_content("Slug: #{@element.slug}")
    expect(page).to have_content("Created: #{@element.p.created_at}")
    expect(page).to have_content("Last Modified: #{@element.p.updated_at}")
    expect(page).to have_content("Template: Default")
  end

end
