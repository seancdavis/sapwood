require 'rails_helper'

feature 'Geocoder', :js => true do

  background do
    @property = property_with_templates
    @element = build(:element)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Elements'
    click_link 'New'
    click_link 'All Options'
  end

  context 'on a new element' do
    scenario 'provides geocode feedback for a valid address' do
      fill_in 'element[template_data][address]', :with => '1216 Central, 45202'
      expect(page).to have_content('1216 Central Pkwy, Cincinnati, OH 45202, USA')
    end
    scenario 'provides feedback if it can not locate an address' do
      fill_in 'element[template_data][address]', :with => 'jkhjklhjkljkhlkjlh'
      expect(page).to have_content('Could not locate')
    end
    scenario 'clears the geocode feedback when address is left blank' do
      fill_in 'element[template_data][address]', :with => 'jkhjklhjkljkhlkjlh'
      fill_in 'element[template_data][address]', :with => ''
      expect(page).to_not have_content('Could not locate')
    end
    scenario 'will save the address and populate it upon return' do
      fill_in 'element[title]', :with => @element.title
      fill_in 'element[template_data][address]', :with => '1216 Central, 45202'
      click_button 'Save All Options'
      click_link @element.title
      value = find_field('element[template_data][address]').value
      expect(value).to eq('1216 Central, 45202')
      expect(page).to have_content('1216 Central Pkwy, Cincinnati, OH 45202, USA')
    end
  end

end
