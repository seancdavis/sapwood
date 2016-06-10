require 'rails_helper'

feature 'Importing Elements', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link 'Edit'
    click_link 'Try it out.'
  end

  scenario 'can be done via csv' do
    attach_file 'property_csv', "#{Rails.root}/spec/support/import.csv"
    select 'All Options', :from => 'property_template_name'
    click_button 'Import Elements'
    expect(page).to have_content('3 elements imported')
    click_link 'Elements'
    expect(page).to have_content('Great American Ballpark')
  end

  scenario 'rescues from a bad column name' do
    attach_file 'property_csv', "#{Rails.root}/spec/support/import_bad_col.csv"
    select 'All Options', :from => 'property_template_name'
    click_button 'Import Elements'
    expect(page).to have_content('one of your column headings does not match')
    click_link 'Elements'
  end

  scenario 'rescues from a bad column name' do
    attach_file 'property_csv', "#{Rails.root}/spec/support/import_bad_data.csv"
    select 'All Options', :from => 'property_template_name'
    click_button 'Import Elements'
    expect(page).to have_content('Data in one of your rows is not valid')
    # Check that it rolls back the entire transaction.
    expect(Element.count).to eq(0)
    click_link 'Elements'
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
