# == Schema Information
#
# Table name: elements
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  property_id   :integer
#  template_name :string
#  template_data :json             default({})
#  publish_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :element do
    property
    title { Faker::Lorem.words(4).join(' ') }
    template_name 'Default'
    template_data {{
      'name' => Faker::Lorem.words(4).join(' ')
    }}
    # publish_at "2016-01-16 16:15:28"
    trait :with_options do
      template_name 'All Options'
      template_data {{
        'name' => Faker::Lorem.words(4).join(' '),
        'comments' => Faker::Lorem.paragraph,
        'image' => create(:document, :title => Faker::Company.bs.titleize).id
      }}
    end
    trait :with_address do
      template_data {{
        'address' => '1216 Central Pkwy, 45202',
        'comments' => Faker::Lorem.paragraph,
        'image' => create(:document, :title => Faker::Company.bs.titleize).id
      }}
    end
  end

end
