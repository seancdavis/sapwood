# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name.gsub(/\'/, '') }
    email { Faker::Internet.email }
    password 'password'
    factory :admin do
      is_admin { true }
    end
  end
end
