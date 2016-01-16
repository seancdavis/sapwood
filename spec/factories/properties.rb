# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  title      :string
#  config     :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :property do
    title "MyString"
config ""
  end

end
