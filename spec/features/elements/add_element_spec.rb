# frozen_string_literal: true

require 'rails_helper'

feature 'Elements', js: true do

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
      fill_in 'element[template_data][name]', with: @title
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

  context 'using AllOptions template' do
    background do
      click_link 'AllOptions'
      click_link 'New AllOptions'
    end
    scenario 'can add an existing image for its image' do
      document = create(:element, :document, property: @property)
      # It's intention that there is only on of these here, although we should
      # consider cases with more than one.
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
      fill_in 'element[template_data][name]', with: @title
      click_button 'Save AllOptions'
      # Let's see if it persisted.
      click_link @title
      expect(page).to have_content(document.title)
    end
    scenario 'adds upload trigger button for document field' do
      expect(page).to have_css('.document-uploader a.upload-trigger')
    end
    scenario 'enables selecting a belongs_to relationship' do
      # This element should be in the dropdown menu.
      element = create(:element, property: @property,
                       template_name: 'One Thing')
      # This element should not.
      default_element = create(:element, property: @property)
      visit current_path
      expect(page).to have_css(
        "select#element_template_data_one_thing option[value='#{element.id}']")
      expect(page).to have_no_css(
        "select#element_template_data_one_thing option[value='#{default_element.id}']")
      fill_in 'element[template_data][name]', with: @title
      select element.title, from: 'element[template_data][one_thing]'
      click_button 'Save AllOptions'
      expect(Element.all.order(:id).last.one_thing).to eq(element)
    end
    scenario 'can select multiple elements of another template' do
      # These elements should be in the dropdown menu.
      els = create_list(:element, 3, property: @property,
                        template_name: 'Many Things')
      # Thes element should not.
      bad_els = [create(:element, property: @property), create(:element)]

      visit current_path
      els.each do |el|
        expect(page).to have_css('div.multiselect option', text: el.title)
      end
      bad_els.each do |el|
        expect(page).to have_no_css('div.multiselect option', text: el.title)
      end

      # Choose 2, remove 1, then save and check.
      select els[0].title, from: 'multiselect_many_things'
      select els[2].title, from: 'multiselect_many_things'
      within('.multiselect.many_things .selected-options') do
        expect(page).to have_css('li > a', text: els[0].title)
        expect(page).to have_no_css('li > a', text: els[1].title)
        expect(page).to have_css('li > a', text: els[2].title)

        # Verify that links are present in the items.
        url = edit_property_template_element_path(@property, els[0].template, els[0])
        expect(page).to have_link(els[0].title, href: url)
        url = edit_property_template_element_path(@property, els[1].template, els[1])
        expect(page).to have_no_link(els[1].title, href: url)
        url = edit_property_template_element_path(@property, els[2].template, els[2])
        expect(page).to have_link(els[2].title, href: url)

        within("li[data-id='#{els[0].id}']") do
          click_link 'REMOVE'
        end

        expect(page).to have_no_css('li > a', text: els[0].title)
        expect(page).to have_no_css('li > a', text: els[1].title)
        expect(page).to have_css('li > a', text: els[2].title)
      end

      fill_in 'element[template_data][name]', with: (title = Faker::Lorem.word)
      click_button 'Save AllOptions'
      click_link title

      within('.multiselect.many_things .selected-options') do
        expect(page).to have_no_css('li > a', text: els[0].title)
        expect(page).to have_no_css('li > a', text: els[1].title)
        expect(page).to have_css('li > a', text: els[2].title)
      end
    end
    scenario 'has a textarea and wysiwyg editor' do
      expect(page).to have_css('textarea#element_template_data_comments',
                               visible: false)
      expect(page).to have_css('div.trumbowyg-box')
    end
    scenario 'supports read-only fields' do
      selector = '[name="element[template_data][uneditable]"].readonly'
      expect(page).to have_css(selector)
    end
    scenario 'supports select fields with a specified set of options' do
      select 'Option 1', from: 'element[template_data][dropdown_menu]'
      fill_in 'element[template_data][name]', with: @title
      click_button 'Save AllOptions'

      el = Element.find_by_title(@title)
      expect(el.dropdown_menu).to eq('Option 1')

      click_link @title
      field = find_field('element[template_data][dropdown_menu]')
      expect(field.value).to eq('Option 1')
    end
    scenario 'saves date fields in the appropriate format' do
      find_field('element[template_data][date]').click
      expect(page).to have_css('.picker--opened', wait: 3)
      first('.picker__button--today').click

      find_field('element[template_data][unformatted_date]').click
      expect(page).to have_css('.picker--opened', wait: 3)
      first('.picker__button--today').click

      fill_in 'element[template_data][name]', with: @title
      click_button 'Save AllOptions'

      el = Element.find_by_title(@title)
      expect(el.date).to eq(Date.today().strftime('%Y-%m-%d'))
      expect(el.unformatted_date).to eq(Date.today().strftime('%m-%d-%Y'))
    end
    scenario 'can check a boolean field' do
      fill_in 'element[template_data][name]', with: @title
      find_field('element[template_data][complete]').set(true)
      click_button 'Save AllOptions'
      expect(Element.find_by_title(@title).complete).to eq(true)
      click_link @title
      expect(find_field('element[template_data][complete]')).to be_checked
    end
  end

end
