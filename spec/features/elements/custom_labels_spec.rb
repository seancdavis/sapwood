require 'rails_helper'

feature 'Element Field Labels', :js => true do

  background do
    @property = property_with_template_file('custom_labels')
    @user = create(:admin)
    sign_in @user
    visit new_property_template_element_path(@property, 'default')
  end


  scenario 'has a custom label for every field type' do
    [
      'STRING LABEL', 'TEXT LABEL', 'GEOCODE LABEL', 'WYSIWYG LABEL',
      'ELEMENT (DOCUMENT) LABEL', 'ELEMENTS (DOCUMENTS) LABEL', 'ELEMENT LABEL',
      'ELEMENTS LABEL', 'Boolean Label', 'SELECT LABEL', 'DATE LABEL'
    ].each do |label|
      expect(page).to have_css('label', :text => label)
    end
  end

end
