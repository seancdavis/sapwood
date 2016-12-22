require 'rails_helper'

feature 'Elements List', :js => true do

  background do
    @property = property_with_templates
    @user = create(:user)
    @user.properties << @property
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
    expect(find('tr:nth-child(1) td.primary')).to have_content('A')
    expect(find('tr:nth-child(2) td.primary')).to have_content('B')
    expect(find('tr:nth-child(3) td.primary')).to have_content('C')

    # And check that the icon is in place.
    within(find('th:nth-child(2)')) do
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
    expect(find('tr.element:nth-child(1)')).to have_content('A')
    expect(find('tr.element:nth-child(2)')).to have_content('B')
    expect(find('tr.element:nth-child(3)')).to have_content('C')
  end

  scenario 'will sort with custom attr and direction if specified' do
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'B' })
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'A' })
    create(:element, :template_name => 'More Options', :property => @property,
           :template_data => { :name => 'C' })
    click_link 'More Options'
    expect(find('tr:nth-child(1) td.primary')).to have_content('C')
    expect(find('tr:nth-child(2) td.primary')).to have_content('B')
    expect(find('tr:nth-child(3) td.primary')).to have_content('A')
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
    within(find('th:nth-child(2)')) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(find('th:nth-child(3)')) do
      expect(page).to have_content('NAME')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end

    within('table') { click_link('Name') }

    # Check that icon transitions to Name, points up, and sorts the elements.
    within(find('th:nth-child(2)')) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(find('th:nth-child(3)')) do
      expect(page).to have_content('NAME')
      expect(page).to have_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    expect(find('tr.element:nth-child(1)')).to have_content('Hello I')
    expect(find('tr.element:nth-child(2)')).to have_content('Hello Me')
    expect(find('tr.element:nth-child(3)')).to have_content('Hello You')

    # Now, sort by name, descending.
    # ---
    # TODO: This fails on Travis because of click coordinates, but can't
    # recreate locally.
    within('table') { find('th a', :text => 'NAME').trigger('click') }

    within(find('th:nth-child(2)')) do
      expect(page).to have_content('DESCRIPTION')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_no_css('.icon-arrow-down')
    end
    within(find('th:nth-child(3)')) do
      expect(page).to have_content('NAME')
      expect(page).to have_no_css('.icon-arrow-up')
      expect(page).to have_css('.icon-arrow-down')
    end
    expect(find('tr.element:nth-child(1)')).to have_content('Hello You')
    expect(find('tr.element:nth-child(2)')).to have_content('Hello Me')
    expect(find('tr.element:nth-child(3)')).to have_content('Hello I')
  end

  scenario 'supports address parts' do
    property = property_with_template_file('address_list')
    @user.properties << property
    el_01 = create(
      :element, :property => property, :template_name => 'Default',
      :template_data => {
        :name => Faker::Lorem.sentence, :address => '1225 Elm St, 45202'
      }
    )
    el_02 = create(
      :element, :property => property, :template_name => 'Default',
      :template_data => {
        :name => Faker::Lorem.sentence, :address => '8 Wall St, 28801'
      }
    )
    el_03 = create(
      :element, :property => property, :template_name => 'Default',
      :template_data => {
        :name => Faker::Lorem.sentence, :address => '1 Ahwahnee Drive, 95389'
      }
    )
    visit deck_path
    click_link property.title
    click_link 'Defaults'

    # Check that we have the address parts.
    expect(page).to have_css('td', :text => '1225 Elm St, 45202')
    expect(page).to have_css('td', :text => 'Cincinnati')
    expect(page).to have_css('td', :text => 'OH')

    # Check headings
    expect(page).to have_css('th', :text => 'LOCATION')
    expect(page).to have_css('th', :text => 'CITY')
    expect(page).to have_css('th', :text => 'US STATE')

    # Sort by city
    within('table') { find('th a', :text => 'CITY').trigger('click') }
    expect(find('tr.element:nth-child(1)')).to have_content('Asheville')
    expect(find('tr.element:nth-child(2)')).to have_content('Cincinnati')
    expect(find('tr.element:nth-child(3)')).to have_content('Yosemite National Park')

    # And state
    within('table') { find('th a', :text => 'US STATE').trigger('click') }
    expect(find('tr.element:nth-child(1)')).to have_content('CA')
    expect(find('tr.element:nth-child(2)')).to have_content('NC')
    expect(find('tr.element:nth-child(3)')).to have_content('OH')
  end

  scenario 'can have a specified page length' do
    el = create(:element, :property => @property,
      :template_name => 'All Options', :template_data => { :name => 'ZZZ' })
    click_link 'All Options'
    within('table') { find('th a', :text => 'NAME').trigger('click') }
    expect(page).to have_content(el.title)
    create_list(:element, 75, :with_options, :property => @property)
    click_link 'All Options'
    within('table') { find('th a', :text => 'NAME').trigger('click') }
    expect(page).to have_no_content(el.title)
  end

  scenario 'supports different column types' do
    property = property_with_template_file('list_options')
    @user.properties << property
    el_01 = create(:element, :property => property, :template_name => 'Date',
                   :template_data => { :date => '2016-10-01' })
    visit deck_path
    click_link property.title
    click_link 'Dates'

    expect(page).to have_content('2016-10-01')
  end

end
