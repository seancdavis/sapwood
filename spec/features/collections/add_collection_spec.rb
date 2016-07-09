require 'rails_helper'

feature 'Collections', :js => true do

  background do
    @property = property_with_templates_and_collection_types
    @elements = create_list(:element, 5, :property => @property)
    @user = create(:admin)
    sign_in @user
    click_link @property.title
  end

  # ---------------------------------------- Default

  context 'using the Default collection type' do

    before(:each) do
      click_link 'Default Collection'
      click_link 'New Default Collection'
    end

    scenario 'can be created with only a title, but title is required' do
      expect(page).to have_no_content(title)
      click_button 'Save'
      expect(page).to have_no_content(title)
      title = Faker::Lorem.words(4).join(' ')
      fill_in 'collection[title]', :with => title
      click_button 'Save'
      expect(page).to have_content(title)
    end

    scenario 'will build a multi-tiered collection' do
      fill_in 'collection[title]', :with => Faker::Lorem.words(4).join(' ')
      first('select.new').first(:option, @elements[0].title).select_option
      expect(page).to have_content(@elements[0].title)
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      expect(page).to have_content(@elements[1].title)
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      expect(page).to have_content(@elements[2].title)
    end

    scenario 'it saves and rebuils the collection' do
      title = Faker::Lorem.words(4).join(' ')
      fill_in 'collection[title]', :with => title
      first('select.new').first(:option, @elements[0].title).select_option
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      click_button 'Save'
      click_link title
      expect(page).to have_css('article.level-1 article.level-2 article.level-3')
      expect(page).to have_content(@elements[0].title)
      expect(page).to have_content(@elements[1].title)
      expect(page).to have_content(@elements[2].title)
    end

    scenario 'it does not allow a fourth level of building' do
      fill_in 'collection[title]', :with => Faker::Lorem.words(4).join(' ')
      first('select.new').first(:option, @elements[0].title).select_option
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      expect(page).to_not have_css('article.level-3 .new-item')
    end

    scenario 'it can remove an item at each level' do
      fill_in 'collection[title]', :with => Faker::Lorem.words(4).join(' ')
      first('select.new').first(:option, @elements[0].title).select_option
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      first('article.level-3 a.remove').click
      expect(page).to have_content(@elements[0].title)
      expect(page).to have_content(@elements[1].title)
      expect(page).to_not have_content(@elements[2].title)
      first('article.level-2 a.remove').click
      expect(page).to have_content(@elements[0].title)
      expect(page).to_not have_content(@elements[1].title)
      first('article.level-1 a.remove').click
      expect(page).to_not have_content(@elements[0].title)
    end

    scenario 'removing a parent removes all its children' do
      fill_in 'collection[title]', :with => Faker::Lorem.words(4).join(' ')
      first('select.new').first(:option, @elements[0].title).select_option
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      first('article.level-1 > a.remove').click
      expect(page).to_not have_content(@elements[0].title)
      expect(page).to_not have_content(@elements[1].title)
      expect(page).to_not have_content(@elements[2].title)
    end

    scenario 'it will save the collection after removing an item' do
      title = Faker::Lorem.words(4).join(' ')
      fill_in 'collection[title]', :with => title
      first('select.new').first(:option, @elements[0].title).select_option
      within('article.item.level-1') do
        first('select.new').first(:option, @elements[1].title).select_option
      end
      within('article.item.level-2') do
        first('select.new').first(:option, @elements[2].title).select_option
      end
      first('article.level-3 a.remove').click
      click_button 'Save'
      click_link title
      expect(page).to have_content(@elements[0].title)
      expect(page).to have_content(@elements[1].title)
      expect(page).to_not have_content(@elements[2].title)
    end
  end

  # ---------------------------------------- All Options

  context 'using the Default collection type' do

    before(:each) do
      click_link 'Loaded Collection'
      click_link 'New Loaded Collection'
    end

    scenario 'can have custom fields from collection type' do
      title = Faker::Lorem.words(4).join(' ')
      fill_in 'collection[title]', :with => title
      desc = Faker::Lorem.sentence
      fill_in 'collection[field_data][description]', :with => desc
      click_button 'Save'
      expect(Collection.first.description).to eq(desc)
    end
  end

end
