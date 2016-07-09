require 'rails_helper'

feature 'Elements List', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Defaults'
  end

  context 'when there are no elements' do
    scenario 'displays a message when there are no elements' do
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are elements' do
    background do
      create(:element, :property => @property)
      visit current_path
    end
    scenario 'does not display a message' do
      expect(page).to_not have_content('Nothing here yet!')
    end
  end

end
