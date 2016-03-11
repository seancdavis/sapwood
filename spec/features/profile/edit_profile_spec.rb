require 'rails_helper'

feature 'My Profile', :js => true do

  background do
    @user = create(:user)
    sign_in @user
  end
  scenario 'lets me change my name' do
    click_link @user.name
    name = Faker::Name.name
    fill_in 'user[name]', :with => name
    click_button 'Save'
    expect(page).to have_content(name)
  end
  scenario 'shows my list of properties' do
    property = create(:property)
    @user.properties << property
    click_link @user.name
    expect(page).to have_content(property.title)
  end

end
