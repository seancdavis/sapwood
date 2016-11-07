require 'rails_helper'

feature 'Elements Search', :js => true do

  background do
    @property = property_with_templates
    %w{pick picking picker picnic}.each do |title|
      create(:element, :property => @property,
             :template_data => { :name => title })
    end
    sign_in (@user = create(:admin))
    click_link @property.title
    click_link 'Defaults'
  end

  scenario 'shows nothing by default' do
    within('aside.main div.search') { expect(page).to have_no_css('li') }
  end

  scenario 'shows nothing when only two characters are typed' do
    fill_in 'search', :with => 'pi'
    wait_for_ajax
    within('aside.main div.search') { expect(page).to have_no_css('li') }
  end

  scenario 'supports partial matches' do
    fill_in 'search', :with => 'pic'
    wait_for_ajax
    within('aside.main div.search') do
      expect(page).to have_css('li', :count => 4)
    end
  end

  scenario 'returns correct results, with stemming' do
    fill_in 'search', :with => 'pick'
    wait_for_ajax
    within('aside.main div.search') do
      expect(page).to have_css('li', :count => 3)
    end
  end

  scenario 'gives feedback when there are no matches' do
    fill_in 'search', :with => 'hello'
    wait_for_ajax
    within('aside.main div.search') do
      expect(page).to have_css('li.no-results')
      expect(page).to have_css('li', :count => 1)
    end
  end

end
