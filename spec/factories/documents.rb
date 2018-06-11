# frozen_string_literal: true

FactoryBot.define do
  factory :document do
    title { nil }
    url 'https://s-media-cache-ak0.pinimg.com/custom_covers/30x30/178947853882959841_1454569459.jpg'
    property
    trait :from_system do
      url { "#{Rails.root}/spec/support/example.png" }
    end
    trait :from_s3 do
      url 'https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill Murray.jpg'
    end
  end
end
