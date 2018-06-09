FactoryBot.define do
  factory :property do
    title { Faker::Lorem.words(4).join(' ').titleize }
    color { Faker::Color.hex_color }
    # templates_raw
  end

end
