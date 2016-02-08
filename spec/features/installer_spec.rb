require 'rails_helper'

feature 'Installer', :js => true do

  before(:each) { remove_config }
  after(:each) { remove_config }

  describe 'Step 1' do
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(1))
      expect(page).to have_css('div.card')
    end
    scenario 'has click through to next step' do
      visit install_path(1)
      click_link 'Next'
      expect(current_path).to eq(install_path(2))
    end
  end

  describe 'Step 2' do
    background do
      Sapwood.set('current_step', 2)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(2))
      expect(page).to have_css('div.card')
    end
    scenario 'has form fill to next step' do
      visit install_path(2)
      fill_in 'install[url]', :with => Faker::Internet.url
      click_button 'Next'
      expect(current_path).to eq(install_path(3))
    end
    scenario 'will not accept a blank URL' do
      visit install_path(2)
      click_button 'Next'
      expect(current_path).to eq(install_path(2))
    end
  end

  describe 'Step 3' do
    background do
      Sapwood.set('current_step', 3)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(3))
      expect(page).to have_css('div.card')
    end
    scenario 'has form fill to next step' do
      visit install_path(3)
      fill_in 'install[name]', :with => Faker::Name.name
      fill_in 'install[email]', :with => Faker::Internet.email
      click_button 'Next'
      expect(current_path).to eq(install_path(4))
    end
    scenario 'will not accept a missing name' do
      visit install_path(3)
      fill_in 'install[email]', :with => Faker::Internet.email
      click_button 'Next'
      expect(current_path).to eq(install_path(3))
    end
    scenario 'will not accept a missing email' do
      visit install_path(3)
      fill_in 'install[name]', :with => Faker::Name.name
      click_button 'Next'
      expect(current_path).to eq(install_path(3))
    end
  end

  describe 'Step 4' do
    background do
      Sapwood.set('current_step', 4)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(4))
      expect(page).to have_css('div.card')
    end
    scenario 'has form fill to next step' do
      visit install_path(4)
      fill_in 'install[user_name]', :with => Faker::Lorem.word
      fill_in 'install[password]', :with => Faker::Internet.password(8)
      fill_in 'install[domain]', :with => Faker::Internet.url
      click_button 'Next'
      expect(current_path).to eq(install_path(5))
    end
    scenario 'will not accept a missing user name' do
      visit install_path(4)
      fill_in 'install[password]', :with => Faker::Internet.password(8)
      fill_in 'install[domain]', :with => Faker::Internet.url
      click_button 'Next'
      expect(current_path).to eq(install_path(4))
    end
    scenario 'will not accept a missing password' do
      visit install_path(4)
      fill_in 'install[user_name]', :with => Faker::Lorem.word
      fill_in 'install[domain]', :with => Faker::Internet.url
      click_button 'Next'
      expect(current_path).to eq(install_path(4))
    end
    scenario 'will not accept a missing domain' do
      visit install_path(4)
      fill_in 'install[user_name]', :with => Faker::Lorem.word
      fill_in 'install[password]', :with => Faker::Internet.password(8)
      click_button 'Next'
      expect(current_path).to eq(install_path(4))
    end
  end

  describe 'Step 5' do
    background do
      Sapwood.set('current_step', 5)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(5))
      expect(page).to have_css('div.card')
    end
    scenario 'has form fill to next step' do
      visit install_path(5)
      fill_in 'install[access_key_id]', :with => Faker::Internet.password(20)
      fill_in 'install[secret_access_key]', :with => Faker::Internet.password(9)
      fill_in 'install[bucket]', :with => Faker::Lorem.word
      click_button 'Next'
      expect(current_path).to eq(install_path(6))
    end
    scenario 'will not accept a missing access key' do
      visit install_path(5)
      fill_in 'install[secret_access_key]', :with => Faker::Internet.password(9)
      fill_in 'install[bucket]', :with => Faker::Lorem.word
      click_button 'Next'
      expect(current_path).to eq(install_path(5))
    end
    scenario 'will not accept a missing secret' do
      visit install_path(5)
      fill_in 'install[access_key_id]', :with => Faker::Internet.password(20)
      fill_in 'install[bucket]', :with => Faker::Lorem.word
      click_button 'Next'
      expect(current_path).to eq(install_path(5))
    end
    scenario 'will not accept a missing bucket' do
      visit install_path(5)
      fill_in 'install[access_key_id]', :with => Faker::Internet.password(20)
      fill_in 'install[secret_access_key]', :with => Faker::Internet.password(9)
      click_button 'Next'
      expect(current_path).to eq(install_path(5))
    end
  end

  describe 'Step 6' do
    background do
      Sapwood.set('current_step', 6)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(6))
      expect(page).to have_css('div.card')
    end
    scenario 'has form fill to next step' do
      visit install_path(6)
      fill_in 'install[name]', :with => Faker::Name.name
      fill_in 'install[email]', :with => Faker::Internet.email
      fill_in 'install[password]', :with => Faker::Internet.password(10)
      click_button 'Next'
      expect(current_path).to eq(install_path(7))
    end
    scenario 'shows name of admin user on next step (Step 7)' do
      visit install_path(6)
      name = Faker::Name.name
      fill_in 'install[name]', :with => name
      fill_in 'install[email]', :with => Faker::Internet.email
      fill_in 'install[password]', :with => Faker::Internet.password(10)
      click_button 'Next'
      expect(page).to have_content(name.upcase)
    end
    scenario 'will not accept a missing name' do
      visit install_path(6)
      fill_in 'install[email]', :with => Faker::Internet.email
      fill_in 'install[password]', :with => Faker::Internet.password(10)
      click_button 'Next'
      expect(current_path).to eq(install_path(6))
    end
    scenario 'will not accept a missing email' do
      visit install_path(6)
      fill_in 'install[name]', :with => Faker::Name.name
      fill_in 'install[password]', :with => Faker::Internet.password(10)
      click_button 'Next'
      expect(current_path).to eq(install_path(6))
    end
    scenario 'will not accept a missing password' do
      visit install_path(6)
      fill_in 'install[name]', :with => Faker::Name.name
      fill_in 'install[email]', :with => Faker::Internet.email
      click_button 'Next'
      expect(current_path).to eq(install_path(6))
    end
  end

  describe 'Step 7' do
    background do
      @admin = create(:admin)
      Sapwood.set('current_step', 7)
      Sapwood.write!
    end
    scenario 'should show the card' do
      visit root_path
      expect(current_path).to eq(install_path(7))
      expect(page).to have_css('div.card')
    end
    scenario 'has click through to finish' do
      visit install_path(7)
      click_link 'Start Using Sapwood'
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'When app has already been installed' do
    background do
      @admin = create(:admin)
      Sapwood.set('current_step', 7)
      Sapwood.set('installed?', true)
      Sapwood.write!
    end
    scenario 'it will not let you visit an install path' do
      visit install_path(1)
      expect(current_path).to eq(new_user_session_path)
    end
  end

end
