require 'rails_helper'

feature 'Elements', :js => true do

  background do
    file = File.expand_path('../../../support/template_config.json', __FILE__)
    @property = create(:property, :templates_raw => File.read(file))
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'using Default template' do
    background do
      @element = create(:element, :property => @property)
      click_link 'Elements'
      click_link @element.title
    end
    scenario 'title can be updated' do
      new_title = Faker::Lorem.words(5).join(' ').titleize
      fill_in 'element[title]', :with => new_title
      click_button 'Save Default'
      expect(page).to have_content(new_title)
    end
    scenario 'will save custom fields' do
      fill_in 'element[title]', :with => @element.title
      subtitle = Faker::Lorem.sentence
      fill_in 'element[template_data][subtitle]', :with => subtitle
      click_button 'Save Default'
      expect(Element.find_by_title(@element.title).subtitle).to eq(subtitle)
    end
    scenario 'has info on the sidebar' do
      expect(page).to have_content("ID: #{@element.id}")
      expect(page).to have_content("Slug: #{@element.slug}")
      expect(page).to have_content("Created: #{@element.p.created_at}")
      expect(page).to have_content("Last Modified: #{@element.p.updated_at}")
      expect(page).to have_content("Template: Default")
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
      @element = create(:element, :property => @property,
                        :template_name => 'All Options')
      click_link 'Elements'
      click_link @element.title
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
  end

end
