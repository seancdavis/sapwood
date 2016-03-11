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

end
