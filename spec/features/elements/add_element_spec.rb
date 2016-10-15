require 'rails_helper'

feature 'Elements', :js => true do

  background do
    @property = property_with_templates
    @element = build(:element)
    @title = Faker::Lorem.words(4).join(' ')
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'using Default template' do
    background do
      click_link 'Defaults'
      click_link 'New Default'
    end
    scenario 'can be created by a user requiring the primary field' do
      # This shows a few things:
      #   - We can save custom field data.
      #   - The index listing shows the primary field by default.
      #   - The primary field is required.
      expect(page).to have_no_content(@title)
      click_button 'Save Default'
      expect(page).to have_no_content(@title)
      fill_in 'element[template_data][name]', :with => @title
      click_button 'Save Default'
      expect(page).to have_content(@title)
    end
    scenario 'only has template on info sidebar' do
      expect(page).to have_no_content('ID:')
      expect(page).to have_no_content('Slug:')
      expect(page).to have_no_content('Created:')
      expect(page).to have_no_content('Last Modified:')
      expect(page).to have_content('Template: Default')
    end
  end

  context 'using All Options template' do
    background do
      add_test_config
      click_link 'All Options'
      click_link 'New All Options'
    end
    scenario 'can add an existing image for its image' do
      document = create(:element, :document, :property => @property)
      # It's intention that there is only on of these here, although we should
      # consider cases with more than one.
      click_link 'Choose Existing File'
      wait_for_ajax
      sleep 0.35
      within('#modal') do
        expect(page).to have_content(document.title, :wait => 5)
        click_link document.title
      end
      sleep 0.35
      within('form') do
        expect(page).to have_content(document.title, :wait => 5)
      end
      fill_in 'element[template_data][name]', :with => @title
      click_button 'Save All Options'
      # Let's see if it persisted.
      click_link @title
      expect(page).to have_content(document.title)
    end
    scenario 'adds upload trigger button for document field' do
      expect(page).to have_css('.document-uploader a.upload-trigger')
    end
    scenario 'enables selecting a belongs_to relationship' do
      # This element should be in the dropdown menu.
      element = create(:element, :property => @property,
                       :template_name => 'One Thing')
      # This element should not.
      default_element = create(:element, :property => @property)
      visit current_path
      expect(page).to have_css(
        "select#element_template_data_one_thing option[value='#{element.id}']")
      expect(page).to have_no_css(
        "select#element_template_data_one_thing option[value='#{default_element.id}']")
      fill_in 'element[template_data][name]', :with => @title
      select element.title, :from => 'element[template_data][one_thing]'
      click_button 'Save All Options'
      expect(Element.all.order(:id).last.one_thing).to eq(element)
    end
    scenario 'can select multiple elements of another template' do
      # These elements should be in the dropdown menu.
      els = create_list(:element, 3, :property => @property,
                        :template_name => 'Many Things')
      # Thes element should not.
      bad_els = [create(:element, :property => @property), create(:element)]

      visit current_path
      els.each do |el|
        expect(page).to have_css('div.multiselect option', :text => el.title)
      end
      bad_els.each do |el|
        expect(page).to have_no_css('div.multiselect option', :text => el.title)
      end

      # Choose 2, remove 1, then save and check.
      select els[0].title, :from => 'multiselect_many_things'
      select els[2].title, :from => 'multiselect_many_things'
      within('.multiselect.many_things .selected-options') do
        expect(page).to have_css('li > span', :text => els[0].title)
        expect(page).to have_no_css('li > span', :text => els[1].title)
        expect(page).to have_css('li > span', :text => els[2].title)

        within("li[data-id='#{els[0].id}']") do
          click_link 'REMOVE'
        end

        expect(page).to have_no_css('li > span', :text => els[0].title)
        expect(page).to have_no_css('li > span', :text => els[1].title)
        expect(page).to have_css('li > span', :text => els[2].title)
      end

      fill_in 'element[template_data][name]', :with => (title = Faker::Lorem.word)
      click_button 'Save All Options'
      click_link title

      within('.multiselect.many_things .selected-options') do
        expect(page).to have_no_css('li > span', :text => els[0].title)
        expect(page).to have_no_css('li > span', :text => els[1].title)
        expect(page).to have_css('li > span', :text => els[2].title)
      end
    end
    scenario 'has a textarea and wysiwyg editor' do
      expect(page).to have_css('textarea#element_template_data_comments',
                               :visible => false)
      expect(page).to have_css('div.trumbowyg-box')
    end
  end

end
