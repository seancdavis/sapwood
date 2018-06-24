FactoryBot.define do
  factory :view do
    title { Faker::Book.title }
    property
    nav_position { rand(0..100) }
    # column_config ""
  end
end
