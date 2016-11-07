# == Schema Information
#
# Table name: property_users
#
#  id          :integer          not null, primary key
#  property_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_admin    :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :property_user do
    property_id 1
user_id 1
  end

end
