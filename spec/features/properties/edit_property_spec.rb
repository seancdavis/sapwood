require 'rails_helper'

feature 'Property Settings', :js => true do

  background do
    @property = create(:property)
    @user = create(:admin)
    sign_in @user
  end

  scenario 'enable a user to update the title' do
    within('.properties') { click_link 'Edit' }
    new_title = Faker::Lorem.words(5).join(' ')
    fill_in 'property[title]', :with => new_title
    click_button 'Save Changes'
    expect(page).to have_content(new_title)
  end

  describe 'hiding sidebar labels' do
    background { within('.properties') { click_link 'Edit' } }
    scenario 'all should be shown/checked by default' do
      expect(page).to have_css('input.label-visibility', :visible => false,
                               :count => 5)
    end
    scenario 'toggling will add a hidden class to the parent' do
      first('.label-input label').click
      expect(page).to have_css('.label-input.hidden', :count => 1)
    end
    scenario 'will hide the sidebar item' do
      expect(page).to have_content('Elements')
      first('.label-input label').click
      click_button 'Save Changes'
      expect(page).to_not have_content('Elements')
    end
  end

end
