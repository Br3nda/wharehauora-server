# frozen_string_literal: true

FactoryBot.define do
  factory :room_type do
    name { Faker::Name.unique.name }
    min_temperature { nil }
    max_temperature { nil }
  end
end
