# == Schema Information
#
# Table name: properties
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  color         :string
#  labels        :json
#  templates_raw :text
#  forms_raw     :text
#

FactoryGirl.define do
  factory :property do
    title { Faker::Lorem.words(4).join(' ') }
    color { Faker::Color.hex_color }
    # labels
    # templates_raw
    # forms_raw
  end

end
