# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    property
    title { nil }
    url 'https://sapwood.s3.amazonaws.com/development/properties/1/xxxxxx-xxxxxx/Bill Murray.jpg'
  end
end
