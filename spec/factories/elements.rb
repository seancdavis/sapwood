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
#  url           :string
#  archived      :boolean          default(FALSE)
#  processed     :boolean          default(FALSE)
#

FactoryBot.define do
  factory :element do
    property
    title { Faker::Lorem.words(4).join(' ') }
    template_name 'Default'
    template_data {{
      'name' => Faker::Lorem.words(4).join(' ').titleize
    }}
    # publish_at "2016-01-16 16:15:28"
    trait :with_options do
      template_name 'All Options'
      template_data {{
        'name' => Faker::Lorem.words(4).join(' ').titleize,
        'comments' => Faker::Lorem.paragraph,
        'image' => create(:element, :document, :property => property,
                          :title => Faker::Company.bs.titleize).id.to_s,
      }}
    end
    trait :with_address do
      template_data {{
        'address' => '1216 Central Pkwy, 45202',
        'comments' => Faker::Lorem.paragraph,
        'image' => create(:element, :document, :property => property,
                          :title => Faker::Company.bs.titleize).id.to_s
      }}
    end
    trait :document do
      title { nil }
      template_name 'Image'
      url 'https://s-media-cache-ak0.pinimg.com/custom_covers/30x30/178947853882959841_1454569459.jpg'
    end
    trait :from_system do
      url { "#{Rails.root}/spec/support/example.png" }
    end
    trait :from_s3 do
      url 'https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill Murray.jpg'
    end
  end

end
