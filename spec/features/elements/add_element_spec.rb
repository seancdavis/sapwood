require 'rails_helper'

feature 'Elements', :js => true do

  background do
    @property = property_with_templates
    @element = build(:element)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Elements'
  end

  context 'using Default template' do
    background do
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
    scenario 'only has template on info sidebar' do
      expect(page).to_not have_content('ID:')
      expect(page).to_not have_content('Slug:')
      expect(page).to_not have_content('Created:')
      expect(page).to_not have_content('Last Modified:')
      expect(page).to have_content('Template: Default')
    end
  end

  context 'using All Options template' do
    background do
      click_link 'New'
      click_link 'All Options'
    end
    scenario 'has the correct placeholder for title' do
      expect(page).to have_css('input[placeholder="Name"]')
    end
  end

end
