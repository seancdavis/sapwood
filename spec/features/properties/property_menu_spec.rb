require 'rails_helper'

feature 'Property Settings', :js => true do

  scenario 'toggles a namespace' do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title

    expect(page).to have_no_content('Child')
    click_link 'Parent'
    expect(page).to have_content('Child')
    click_link 'Parent'
    expect(page).to have_no_content('Child')

    click_link 'Parent'
    click_link 'Child'
    visit current_path
    # Show that the menu is open when we land on that page
    within('aside') do
      expect(page).to have_content('Child')
    end
  end

end
