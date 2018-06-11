FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'
    factory :admin do
      is_admin { true }
    end
  end
end
