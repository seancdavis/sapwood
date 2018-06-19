# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user
    property
    template_name { 'Default' }
  end
end
