require 'rails_helper'

feature 'My Profile', js: true do

  background do
    @property = create(:property)
    @user = create(:user, name: nil)
    @user.properties << @property
    sign_in @user
  end
  scenario 'must be completed before I move on' do
    # Shows messages by default.
    expect(page).to have_content('Add your name.')
    expect(page).to have_content('Set a password for your account.')
    expect(page).to have_content('You need to complete your profile.')
    # Show that we can't navigate anywhere.
    visit deck_path
    expect(page).to have_content('Add your name.')
    expect(page).to have_content('Set a password for your account.')
    expect(page).to have_content('You need to complete your profile.')
    # Try to save but messages remain.
    click_button 'Save'
    expect(page).to have_content('Add your name.')
    expect(page).to have_content('Set a password for your account.')
    expect(page).to have_content('You need to complete your profile.')
    # Fill in name and passwords, then save and and REGULAR USER is redirected
    # to first property.
    fill_in 'user[name]', with: Faker::Name.name
    fill_in 'user[password]', with: 'hello_world'
    fill_in 'user[password_confirmation]', with: 'hello_world'
    click_button 'Save'
    expect(current_path).to eq(property_path(@property))
  end

end
