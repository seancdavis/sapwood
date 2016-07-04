require 'rails_helper'

feature 'Documents List', :js => true do

  background do
    add_test_config
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Documents'
  end

  context 'when there are no documents' do
    scenario 'displays a message when there are no documents' do
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are documents' do
    background do
      create(:document, :property => @property)
      visit current_path
    end
    scenario 'does not display a message' do
      expect(page).to_not have_content('Nothing here yet!')
    end
  end

end
