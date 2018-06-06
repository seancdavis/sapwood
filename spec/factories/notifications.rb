# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  property_id   :integer
#  template_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :notification do
    user
    property
    template_name { 'Default' }
  end
end
