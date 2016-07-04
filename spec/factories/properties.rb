# == Schema Information
#
# Table name: properties
#
#  id              :integer          not null, primary key
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  color           :string
#  labels          :json
#  templates_raw   :text
#  forms_raw       :text
#  hidden_labels   :text             default([]), is an Array
#  api_key         :string
#  collections_raw :text
#

FactoryGirl.define do
  factory :property do
    title { Faker::Lorem.words(4).join(' ').titleize }
    color { Faker::Color.hex_color }
    # templates_raw
    # forms_raw
    trait :with_labels do
      labels {
        {
          :elements => "Elements",
          :documents => "Documents",
          :collections => "Collections",
          :responses => "Responses",
          :users => 'Users'
        }
      }
    end
  end

end
