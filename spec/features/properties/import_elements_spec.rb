require 'rails_helper'

feature 'Importing Elements', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link 'Edit'
    click_link 'Try it out.'
  end

  scenario 'enable a user to update the title' do
    attach_file 'property_csv', "#{Rails.root}/spec/support/import.csv"
    select 'All Options', :from => 'property_template_name'
    click_button 'Import Elements'
    expect(page).to have_content('3 elements imported')
    click_link 'Elements'
    expect(page).to have_content('Great American Ballpark')
  end

  scenario 'requires file to import' do
    expect(page).to have_css('input#property_csv[required]')
    select 'All Options', :from => 'property_template_name'
    click_button 'Import Elements'
    expect(current_path).to eq(property_import_path(@property))
  end

  scenario 'requires template name to import' do
    expect(page).to have_css('select#property_template_name[required]')
    # Form was still being submitted even though field was required -- sticking
    # to css check for now.
  end

end
