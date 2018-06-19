# frozen_string_literal: true

require 'rails_helper'

feature 'Property', js: true do

  background do
    @property = property_with_templates
    @user = create(:user)
    @user.properties << @property
    sign_in @user
  end

  scenario 'shows empty block when no elements' do
    click_link @property.title
    expect(page).to have_content('Nothing here!')
  end

  context 'with elements' do
    background do
      (@titles = %w{Pick Picking Picker Picnic Farts}).each do |title|
        create(:element, property: @property,
               template_data: { name: title })
      end
    end
    scenario 'adds newest created items only to newest list' do
      click_link @property.title
      within(first('.block.half')) do
        @titles.each { |t| expect(page).to have_no_content(t) }
      end
      within(all('.block.half').last) do
        @titles.each { |t| expect(page).to have_content(t) }
      end
    end
    scenario 'last updated are those where updated_at does not match' do
      el = Element.find_by_title('Farts')
      el.update!(slug: 'hello-world')
      click_link @property.title
      within(first('.block.half')) do
        expect(page).to have_content('Farts')
      end
    end
    scenario 'does not show elements without a template' do
      el = @property.elements.find_by_title('Picnic')
      el.update(template_name: 'Wrong Template Name!')
      click_link @property.title
      expect(page).to have_no_content('Picnic')
    end
    scenario 'has a functioning search box' do
      click_link @property.title
      # The sidebar should not have a search box.
      expect(page).to have_no_css('aside .search input')
      # There should be no results
      within('.quiet.search') { expect(page).to have_no_css('li') }
      # But will render matches.
      fill_in 'search', with: 'pick'
      wait_for_ajax
      within('.quiet.search') { expect(page).to have_css('li', count: 3) }
    end
  end

end
