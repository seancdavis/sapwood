require 'rails_helper'

feature 'Geocoder', :js => true do

  context 'on a new element' do
    background do
      @property = property_with_templates
      @element = build(:element)
      @user = create(:admin)
      sign_in @user
      click_link @property.title
      click_link 'All Options'
      click_link 'New All Options'
    end
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
      expect(page).to have_no_content('Could not locate')
    end
    scenario 'will save the address and populate it upon return' do
      fill_in 'element[template_data][name]', :with => @element.title
      fill_in 'element[template_data][address]', :with => '1216 Central, 45202'
      click_button 'Save All Options'
      click_link @element.title
      value = find_field('element[template_data][address]').value
      expect(value).to eq('1216 Central, 45202')
      expect(page).to have_content('1216 Central Pkwy, Cincinnati, OH 45202, USA')
    end
  end

  context 'on an existing element' do
    background do
      @address = '1216 Central, 45202'
      @property = property_with_templates
      @element = create(:element, :property => @property,
                        :template_name => 'All Options',
                        :template_data => {
                          :name => Faker::Lorem.words(4).join(' '),
                          :address => @address
                        })
      @user = create(:admin)
      sign_in @user
      click_link @property.title
      click_link 'All Options'
      click_link @element.title
    end
    scenario 'adds the content to textarea' do
      expect(find_field('element[template_data][address]').value)
        .to eq(@address)
    end
    scenario 'automatically geocodes a valid address' do
      expect(page).to have_content('1216 Central Pkwy, Cincinnati, OH 45202, USA')
    end
    scenario 'provides geocode feedback for a valid address' do
      fill_in 'element[template_data][address]', :with => 'lytle place, 45202'
      expect(page).to have_content('Lytle Pl, Cincinnati, OH 45202, USA')
    end
    scenario 'provides feedback if it can not locate an address' do
      fill_in 'element[template_data][address]', :with => 'jkhjklhjkljkhlkjlh'
      expect(page).to have_content('Could not locate')
    end
    scenario 'clears the geocode feedback when address is left blank' do
      fill_in 'element[template_data][address]', :with => 'jkhjklhjkljkhlkjlh'
      fill_in 'element[template_data][address]', :with => ''
      expect(page).to have_no_content('Could not locate')
    end
    scenario 'will save the address and populate it upon return' do
      fill_in 'element[template_data][name]', :with => @element.title
      fill_in 'element[template_data][address]', :with => 'lytle place, 45202'
      click_button 'Save All Options'
      click_link @element.title
      value = find_field('element[template_data][address]').value
      expect(value).to eq('lytle place, 45202')
      expect(page).to have_content('Lytle Pl, Cincinnati, OH 45202, USA')
    end
  end

end
