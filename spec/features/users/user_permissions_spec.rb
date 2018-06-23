require 'rails_helper'

feature 'Users', js: true do

  context 'as an admin' do
    background do
      @properties = create_list(:property, 3)
      @p_01 = @properties[0]
      @p_02 = @properties[1]
      @p_03 = @properties[2]
      @element = build(:element)
      @user = create(:user)
      @user.properties << @p_01
      @admin = create(:admin)
      sign_in @admin
      click_link @p_01.title
      first('.dropdown a.trigger').click
      click_link 'Users'
    end

    context 'for an existing user' do
      background do
        click_link @user.name
      end
      scenario 'can be made an editor of a property' do
        first("label[for='access-editor-#{@p_03.id}']").click
        click_button 'Save'
        expect(@user.has_access_to?(@p_03)).to eq(true)
        expect(@user.is_admin_of?(@p_03)).to eq(false)
      end
      scenario 'can be made an admin of a property' do
        first("label[for='access-admin-#{@p_03.id}']").click
        click_button 'Save'
        expect(@user.has_access_to?(@p_03)).to eq(true)
        expect(@user.is_admin_of?(@p_03)).to eq(true)
      end
      scenario 'auto-toggles permissions' do
        page.execute_script("$('.switch input').addClass('capybara-override');")
        expect(page).to have_no_checked_field("access-editor-#{@p_03.id}")
        expect(page).to have_no_checked_field("access-admin-#{@p_03.id}")
        # Click editor and admin is still unchecked.
        first("label[for='access-editor-#{@p_03.id}']").click
        expect(page).to have_checked_field("access-editor-#{@p_03.id}")
        expect(page).to have_no_checked_field("access-admin-#{@p_03.id}")
        # Click admin and both get checked
        first("label[for='access-editor-#{@p_03.id}']").click # uncheck editor
        first("label[for='access-admin-#{@p_03.id}']").click
        expect(page).to have_checked_field("access-editor-#{@p_03.id}")
        expect(page).to have_checked_field("access-admin-#{@p_03.id}")
        # Click editor when admin is checked and it unchecks both
        first("label[for='access-editor-#{@p_03.id}']").click
        expect(page).to have_no_checked_field("access-editor-#{@p_03.id}")
        expect(page).to have_no_checked_field("access-admin-#{@p_03.id}")
      end
      scenario 'shows the properties when user is not set to admin' do
        expect(page).to have_content(@p_03.title)
      end
      scenario 'does not show admin message when not set to admin' do
        expect(page).to have_no_content('Admin users have access to all')
      end
      scenario 'does not show the properties when user is not set to admin' do
        first("label[for='user_is_admin']").click
        expect(page).to have_no_content(@p_03.title)
      end
      scenario 'shows admin message when not set to admin' do
        first("label[for='user_is_admin']").click
        expect(page).to have_content('Admin users have access to all')
      end
      scenario 'can be removed from the current property' do
        first("label[for='access-editor-#{@p_01.id}']").click
        click_button 'Save'
        expect(page).to have_no_content(@user.name)
        expect(page).to have_no_content(@user.email)
      end
    end

    context 'for a new user' do
      background do
        click_link 'New User'
      end
      scenario 'does not have current property name in the sidebar' do
        within('.properties-list') do
          expect(page).to have_no_content(@p_01.title)
        end
      end
      scenario 'shows message for property auto-add' do
        within('.body aside') do
          expect(page)
            .to have_content("automatically be added to the #{@p_01.title}")
        end
      end
      scenario 'is automatically added to the current property' do
        email = Faker::Internet.email
        fill_in 'user[email]', with: email
        click_button 'Save'
        expect(page).to have_content(email)
      end
    end
  end

end
