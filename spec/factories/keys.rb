FactoryBot.define do
  factory :key do
    property
    value { SecureRandom.hex(24) }

    trait :writeable do
      writeable true
      template_names { ['Default'] }
    end
  end
end
