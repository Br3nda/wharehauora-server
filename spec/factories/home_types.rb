# frozen_string_literal: true

FactoryBot.define do
  factory :home_type do
    name { Faker::Name.unique.name }
  end
end
