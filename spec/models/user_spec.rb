# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  name                   :string
#  sign_in_key            :string
#

require 'rails_helper'

RSpec.describe User, :type => :model do

  describe '#accessible_properties' do
    before(:each) do
      @properties = create_list(:property, 5)
    end
    it 'returns all properties for an admin user' do
      expect(create(:admin).accessible_properties.size).to eq(5)
    end
    it 'returns only associated properties for regular users' do
      user = create(:user)
      user.properties << @properties.first
      expect(user.accessible_properties.size).to eq(1)
    end
  end

  describe '#has_access_to?(property)' do
    before(:each) do
      @properties = create_list(:property, 5)
    end
    it 'returns true for each property' do
      admin = create(:admin)
      @properties.each do |p|
        expect(admin.has_access_to?(p)).to eq(true)
      end
    end
    it 'returns true for non-admins if they have been added' do
      user = create(:user)
      user.properties << @properties.first
      expect(user.has_access_to?(@properties.first)).to eq(true)
    end
    it 'returns false for non-admins if they have not been added' do
      user = create(:user)
      @properties.each do |p|
        expect(user.has_access_to?(p)).to eq(false)
      end
    end
  end

  describe '#set_properties!' do
    it 'adds the user to the given set of properties' do
      p_01 = create(:property)
      p_02 = create(:property)
      p_03 = create(:property)
      user = create(:user)
      user.set_properties!([p_01.id, p_02.id])
      user = User.find_by_id(user.id)
      expect(user.has_access_to?(p_01)).to eq(true)
      expect(user.has_access_to?(p_02)).to eq(true)
      expect(user.has_access_to?(p_03)).to eq(false)
    end
  end

  describe '#is_admin_of?' do
    before(:each) { @property = create(:property) }
    it 'returns true for admins' do
      expect(create(:admin).is_admin_of?(@property)).to eq(true)
    end
    it 'returns true for property admins' do
      user = create(:user)
      user.properties << @property
      user.property_users.first.update(:is_admin => true)
      user = User.find_by_id(user.id)
      expect(user.is_admin_of?(@property)).to eq(true)
    end
    it 'returns false for content editors' do
      user = create(:user)
      user.properties << @property
      user = User.find_by_id(user.id)
      expect(user.is_admin_of?(@property)).to eq(false)
    end
    it 'returns false for those without access' do
      expect(create(:user).is_admin_of?(@property)).to eq(false)
    end
  end

  describe '#make_admin_in_properties  !' do
    it 'adds the user to the given set of properties' do
      p_01 = create(:property)
      p_02 = create(:property)
      p_03 = create(:property)
      user = create(:user)
      user.set_properties!([p_01.id, p_02.id])
      user.make_admin_in_properties!([p_01.id])
      user = User.find_by_id(user.id)
      expect(user.is_admin_of?(p_01)).to eq(true)
      expect(user.is_admin_of?(p_02)).to eq(false)
      expect(user.is_admin_of?(p_03)).to eq(false)
    end
  end

end
