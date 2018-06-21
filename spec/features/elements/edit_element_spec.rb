# frozen_string_literal: true

require 'rails_helper'

feature 'Elements', js: true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'using Default template' do
    background do
      @element = create(:element, property: @property)
      click_link 'Defaults'
      click_link @element.title
    end
    scenario 'name (custom field) can be updated' do
      new_title = Faker::Lorem.words(5).join(' ').titleize
      fill_in 'element[template_data][name]', with: new_title
      click_button 'Save Default'
      expect(page).to have_content(new_title)
    end
    scenario 'has info on the sidebar' do
      expect(page).to have_content("ID: #{@element.id}")
      expect(page).to have_content("Slug: #{@element.slug}")
      expect(page).to have_content("Created: #{@element.formatted_date(:created_at)}")
      expect(page).to have_content("Last Modified: #{@element.formatted_date(:updated_at)}")
      expect(page).to have_content('Template: Default')
    end
  end

  context 'using AllOptions template' do
    background do
      @element = create(:element, property: @property,
                        template_name: 'AllOptions')
      click_link 'AllOptions'
      click_link @element.title
    end
    scenario 'can add an existing image for its image' do
      document = create(:element, :document, property: @property)
      click_link 'Choose Existing File'
      wait_for_ajax
      sleep 0.35
      within('#modal') do
        expect(page).to have_content(document.title, wait: 5)
        click_link document.title
      end
      sleep 0.35
      within('form') do
        expect(page).to have_content(document.title, wait: 5)
      end
      # Let's see if it persisted.
      click_button 'Save AllOptions'
      click_link @element.title
      expect(page).to have_content(document.title)
    end
    scenario 'can add multiple existing images for its image' do
      document_01 = create(:element, :document, property: @property,
                           title: Faker::Company.bs.titleize)
      document_02 = create(:element, :document, property: @property,
                           title: Faker::Company.bs.titleize)
      document_03 = create(:element, :document, property: @property,
                           title: Faker::Company.bs.titleize)
      click_link 'Choose Existing Files'
      wait_for_ajax
      sleep 0.35
      # Show that we can click all three, and that clicking a second time
      # deselects it as an option.
      within('#modal') do
        expect(page).to have_content(document_01.title, wait: 5)
        click_link document_01.title
        click_link document_02.title
        click_link document_03.title
        click_link document_01.title
        click_link 'Save & Close'
      end
      sleep 0.35
      within('form') do
        expect(page).to have_content(document_02.title, wait: 5)
        expect(page).to have_content(document_03.title)
        expect(page).to have_no_content(document_01.title)
      end
      # Let's see if it persisted.
      click_button 'Save AllOptions'
      click_link @element.title
      within('form') do
        expect(page).to have_content(document_02.title, wait: 5)
        expect(page).to have_content(document_03.title)
        expect(page).to have_no_content(document_01.title)
      end
    end
    scenario 'adds upload trigger button for document(s) field' do
      expect(page).to have_css('.document-uploader a.upload-trigger')
      expect(page).to have_css('.bulk-document-uploader a.upload-trigger')
    end
    scenario 'adds a form for uploading' do
      expect(page).to have_css('section.uploader > form', visible: false)
    end
    scenario 'can remove an uploaded document' do
      doc = create(:element, :document, property: @property,
                   title: Faker::Company.bs.titleize)
      td = @element.template_data
      @element.update!(template_data: td.merge(image: doc.id.to_s))
      visit current_path
      within('.document-uploader') do
        expect(page).to have_content(doc.title)
        click_link 'REMOVE'
      end
      click_button 'Save AllOptions'
      expect(@element.reload.image).to eq(nil)
      click_link @element.title
      expect(page).to have_no_content(doc.title)
    end
    scenario 'has a textarea' do
      expect(page).to have_css('textarea#element_template_data_comments',
                               visible: false)
      expect(page).to have_css('div.trumbowyg-box')
    end
  end

end
