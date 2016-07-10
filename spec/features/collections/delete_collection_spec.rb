require 'rails_helper'

feature 'Collections', :js => true do

  scenario 'can be deleted' do
    property = property_with_templates_and_collection_types
    @user = create(:admin)
    collection = create(:collection, :property => property)
    sign_in @user
    visit property_collection_type_collections_path(property, 'default-collection')
    expect(page).to have_content(collection.title)
    click_link collection.title
    click_link 'Delete Default Collection'
    expect(page).to have_no_content(collection.title)
  end

end
