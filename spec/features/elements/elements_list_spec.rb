require 'rails_helper'

feature 'Elements List', :js => true do

  background do
    @property = property_with_templates
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  context 'when there are no elements' do
    scenario 'displays a message when there are no elements' do
      click_link 'Defaults'
      expect(page).to have_content('Nothing here!')
    end
  end

  context 'when there are elements' do
    scenario 'only shows those belonging to the current template' do
      element_01 = create(:element, :property => @property)
      element_02 = create(:element, :with_options, :property => @property)
      click_link 'Defaults'
      expect(page).to have_no_content('Nothing here yet!')
      expect(page).to have_content(element_01.title)
      expect(page).to have_no_content(element_02.title)
    end
  end

  scenario 'allows for a custom table config, but has a default' do
    # First, test out the default layout.
    element_01 = create(:element, :property => @property)
    click_link 'Defaults'
    # "name" is assumed as the primary, even though it is not set.
    expect(page).to have_css(:th, :text => 'NAME')
    expect(page).to have_no_css(:th, :text => 'DESCRIPTION')
    expect(page).to have_css(:th, :text => 'LAST MODIFIED')
    # And the custom layout.
    element_01 = create(:element, :with_options, :property => @property)
    click_link 'All Options'
    expect(page).to have_css(:th, :text => 'NAME')
    expect(page).to have_css(:th, :text => 'DESCRIPTION')
    expect(page).to have_css(:th, :text => 'DATE LAST MODIFIED')
  end

  scenario 'sorts by name in ascending order when not specified' do
    create(:element, :template_name => 'Default', :property => @property,
           :template_data => { :name => 'B' })
    create(:element, :template_name => 'Default', :property => @property,
           :template_data => { :name => 'A' })
    create(:element, :template_name => 'Default', :property => @property,
           :template_data => { :name => 'C' })
    click_link 'Defaults'
    expect(all('td.primary')[0]).to have_content('A')
    expect(all('td.primary')[1]).to have_content('B')
    expect(all('td.primary')[2]).to have_content('C')

    # And check that the icon is in place.
    within(all('th')[1]) do
      expect(page).to have_content('NAME')
      expect(page).to have_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
  end

  scenario 'sorts by custom attr in ascending order when order is missing' do
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello You', :description => 'B' })
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello Me', :description => 'A' })
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello I', :description => 'C' })
    click_link 'All Options'
    expect(all('tr.element')[0]).to have_content('A')
    expect(all('tr.element')[1]).to have_content('B')
    expect(all('tr.element')[2]).to have_content('C')
  end

  scenario 'will sort with custom attr and direction if specified' do
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'B' })
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'A' })
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'C' })
    click_link 'More Options'
    expect(all('td.primary')[0]).to have_content('C')
    expect(all('td.primary')[1]).to have_content('B')
    expect(all('td.primary')[2]).to have_content('A')
  end

  scenario 'can sort manually when clicked' do
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello You', :description => 'B' })
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello Me', :description => 'A' })
    create(:element, :template_name => 'All Options', :property => @property,
           :template_data => { :name => 'Hello I', :description => 'C' })

    click_link 'All Options'

    # Check the default icon on description, pointing up.
    within(all('th')[1]) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(all('th')[2]) do
      expect(page).to have_content('NAME')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end

    within('table') { click_link('Name') }

    # Check that icon transitions to Name, points up, and sorts the elements.
    within(all('th')[1]) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(all('th')[2]) do
      expect(page).to have_content('NAME')
      expect(page).to have_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    expect(all('tr.element')[0]).to have_content('Hello I')
    expect(all('tr.element')[1]).to have_content('Hello Me')
    expect(all('tr.element')[2]).to have_content('Hello You')

    # Now, sort by name, descending.
    within('table') { click_link('Name') }

    within(all('th')[1]) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(all('th')[2]) do
      expect(page).to have_content('NAME')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_css('.icon-arrow-down')
    end
    expect(all('tr.element')[0]).to have_content('Hello You')
    expect(all('tr.element')[1]).to have_content('Hello Me')
    expect(all('tr.element')[2]).to have_content('Hello I')
  end

end
