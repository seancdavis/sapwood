require 'rails_helper'

feature 'Elements', :js => true do

  background do
    @property = property_with_templates
    @element = build(:element)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'using Default template' do
    background do
      click_link 'Defaults'
      click_link 'New Default'
    end
    scenario 'can be created by a user with the basics' do
      fill_in 'element[title]', :with => @element.title
      click_button 'Save Default'
      expect(page).to have_content(@element.title)
    end
    scenario 'will save custom fields' do
      fill_in 'element[title]', :with => @element.title
      subtitle = Faker::Lorem.sentence
      fill_in 'element[template_data][subtitle]', :with => subtitle
      click_button 'Save Default'
      expect(Element.find_by_title(@element.title).subtitle).to eq(subtitle)
    end
    scenario 'only has template on info sidebar' do
      expect(page).to_not have_content('ID:')
      expect(page).to_not have_content('Slug:')
      expect(page).to_not have_content('Created:')
      expect(page).to_not have_content('Last Modified:')
      expect(page).to have_content('Template: Default')
    end
    scenario 'has a body' do
      expect(page).to have_css('textarea#element_body', :visible => false)
    end
    scenario 'uses a wysiwyg editor for the body' do
      expect(page).to have_css('div.trumbowyg-box')
    end
  end

  context 'using All Options template' do
    background do
      add_test_config
      click_link 'All Options'
      click_link 'New All Options'
    end
    scenario 'can add an existing image for its image' do
      document = create(:document, :property => @property)
      click_link 'Choose Existing File'
      wait_for_ajax
      click_link document.title
      sleep 0.35
      within('form') { expect(page).to have_content(document.title) }
      fill_in 'element[title]', :with => @element.title
      click_button 'Save All Options'
      # Let's see if it persisted.
      click_link @element.title
      expect(page).to have_content(document.title)
    end
    scenario 'has the correct placeholder for title' do
      expect(page).to have_css('input[placeholder="Name"]')
    end
    scenario 'hides the body field' do
      expect(page).to_not have_css('textarea#element_body')
    end
    scenario 'adds upload trigger button for document field' do
      expect(page).to have_css('.document-uploader a.upload-trigger')
    end
    scenario 'adds a form for uploading' do
      expect(page).to have_css('section.uploader > form', :visible => false)
    end
    scenario 'enables selecting a belongs_to relationship' do
      # This element should be in the dropdown menu.
      element = create(:element, :property => @property,
                       :template_name => 'More Options')
      # This element should not.
      default_element = create(:element, :property => @property)
      visit current_path
      expect(page).to have_css(
        "select#element_template_data_option option[value='#{element.id}']")
      expect(page).to have_no_css(
        "select#element_template_data_option option[value='#{default_element.id}']")
      fill_in 'element[title]', :with => @element.title
      select element.title, :from => 'element[template_data][option]'
      click_button 'Save All Options'
      expect(Element.all.order(:id).last.option).to eq(element)
    end
    scenario 'has a textarea' do
      expect(page).to have_css('textarea#element_template_data_comments',
                               :visible => false)
    end
    scenario 'uses a wysiwyg editor for comments' do
      # we know there should be only one wysiwyg editor because the body is
      # hidden for this template
      expect(page).to have_css('div.trumbowyg-box')
    end
  end

end
