require 'rails_helper'

feature 'Elements List', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'when there are no elements' do
    scenario 'displays a message when there are no elements' do
      click_link 'Defaults'
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are elements' do
    scenario 'only shows those belonging to the current template' do
      element_01 = create(:element, :property => @property)
      element_02 = create(:element, :with_options, :property => @property)
      click_link 'Defaults'
      expect(page).to_not have_content('Nothing here yet!')
      expect(page).to have_content(element_01.title)
      expect(page).to have_no_content(element_02.title)
    end
  end

end
