# == Schema Information
#
# Table name: collections
#
#  id                   :integer          not null, primary key
#  title                :string
#  property_id          :integer
#  item_data            :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  collection_type_name :string
#  field_data           :json
#

FactoryGirl.define do
  factory :collection do
    property
    title { Faker::App.name }
    collection_type_name 'Collection'
    item_data {{}}
    trait :with_items do
      after(:create) do |collection|
        e = create_list(:element, 5, :property => collection.property)
        item_data = [
          {
            'id' => e[0].id,
            'title' => e[0].title,
            'children' => [
              {
                'id' => e[1].id,
                'title' => e[1].title,
                'children' => [
                  { 'id' => e[2].id, 'title' => e[2].title },
                  { 'id' => e[3].id, 'title' => e[3].title }
                ]
              }
            ]
          },
          { 'id' => e[4].id, 'title' => e[4].title, 'children' => [] }
        ]
        collection.item_data_will_change!
        collection.update!(:item_data => item_data.to_json)
      end
    end
  end

end
