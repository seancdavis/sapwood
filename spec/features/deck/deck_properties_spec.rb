require 'rails_helper'

feature 'Deck', :js => true do

  context 'as an admin' do
    background do
      @properties = create_list(:property, 3)
      @element = build(:element)
      @admin = create(:admin)
      sign_in @admin
    end
    scenario 'can see all properties' do
      @properties.each do |property|
        expect(page).to have_content(property.title)
      end
    end
    scenario 'sees button to create new property' do
      expect(page).to have_content('NEW PROPERTY')
    end
  end

  context 'as a regular user' do
    background do
      @properties = create_list(:property, 3)
      @property = @properties.first
      @element = build(:element)
      @user = create(:user)
      @user.properties << @property
      sign_in @user
    end
    scenario 'can see all properties' do
      expect(page).to have_content(@property.title)
      (@properties - [@property]).each do |property|
        expect(page).to_not have_content(property.title)
      end
    end
    scenario 'does not see button to create new property' do
      expect(page).to_not have_content('NEW PROPERTY')
    end
  end

end
