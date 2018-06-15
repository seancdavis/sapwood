FactoryBot.define do
  factory :key do
    title { Faker::Book.title }
    property
    value { SecureRandom.hex(24) }

    trait :writeable do
      writeable true
      template_names { ['Default'] }
    end
  end
end
