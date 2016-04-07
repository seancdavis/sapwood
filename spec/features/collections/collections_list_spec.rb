require 'rails_helper'

feature 'Collections List', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
    click_link 'Collections'
  end

  context 'when there are no collections' do
    scenario 'displays a message when there are no collections' do
      expect(page).to have_content('Nothing here yet!')
    end
  end

  context 'when there are collections' do
    background do
      create(:collection, :property => @property)
      visit current_path
    end
    scenario 'does not display a message' do
      expect(page).to_not have_content('Nothing here yet!')
    end
  end

end
