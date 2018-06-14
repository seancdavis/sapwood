FactoryBot.define do
  factory :key do
    property_id 1
    writeable false
    template_names ""
    encrypted_value "MyString"
  end
end
