# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  templates_raw :text
#  api_key       :string
#

FactoryBot.define do
  factory :property do
    title { Faker::Lorem.words(4).join(' ').titleize }
    color { Faker::Color.hex_color }
    # templates_raw
  end

end
