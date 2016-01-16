# == Schema Information
#
# Table name: responses
#
#  id          :integer          not null, primary key
#  property_id :integer
#  data        :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :response do
    property_id 1
data ""
  end

end
