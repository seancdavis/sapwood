require 'rails_helper'

feature 'Users', :js => true do

  context 'as an admin' do
    background do
      @properties = create_list(:property, 3)
      @property = @properties.first
      @element = build(:element)
      @user = create(:user)
      @user.properties << @property
      @admin = create(:admin)
      sign_in @admin
      click_link @property.title
      click_link 'Users'
    end

    context 'for an existing user' do
      background do
        click_link @user.name
      end
      scenario 'can be assigned to a property' do
        first("label[for='access-#{@properties.last.id}']").click
        click_button 'Save'
        expect(@user.has_access_to?(@properties.last)).to eq(true)
      end
      scenario 'shows the properties when user is not set to admin' do
        expect(page).to have_content(@properties.last.title)
      end
      scenario 'does not show admin message when not set to admin' do
        expect(page).to_not have_content('Admin users have access to all')
      end
      scenario 'does not show the properties when user is not set to admin' do
        first("label[for='user_is_admin']").click
        expect(page).to_not have_content(@properties.last.title)
      end
      scenario 'shows admin message when not set to admin' do
        first("label[for='user_is_admin']").click
        expect(page).to have_content('Admin users have access to all')
      end
      scenario 'can be removed from the current property' do
        within('.properties-list') do
          first('span.label', :text => @property.title).click
        end
        click_button 'Save'
        expect(page).to_not have_content(@user.name)
        expect(page).to_not have_content(@user.email)
      end
    end

    context 'for a new user' do
      background do
        click_link 'New User'
      end
      scenario 'does not have current property name in the sidebar' do
        within('.properties-list') do
          expect(page).to_not have_content(@property.title)
        end
      end
      scenario 'shows message for property auto-add' do
        within('.body aside') do
          expect(page)
            .to have_content("automatically be added to the #{@property.title}")
        end
      end
      scenario 'is automatically added to the current property' do
        email = Faker::Internet.email
        fill_in 'user[email]', :with => email
        click_button 'Save'
        expect(page).to have_content(email)
      end
    end
  end

end
