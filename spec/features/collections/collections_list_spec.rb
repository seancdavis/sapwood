require 'rails_helper'

feature 'Collections List', :js => true do

  background do
    @property = property_with_templates_and_collection_types
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'when there are no collections' do
    scenario 'displays a message when there are no collections' do
      click_link 'Default Collections'
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are collections' do
    scenario 'only shows those belonging to the current type' do
      collection_01 = create(:collection, :property => @property)
      collection_02 = create(:collection, :with_options, :property => @property)
      click_link 'Default Collections'
      expect(page).to_not have_content('Nothing here yet!')
      expect(page).to have_content(collection_01.title)
      expect(page).to have_no_content(collection_02.title)
    end
  end

end
