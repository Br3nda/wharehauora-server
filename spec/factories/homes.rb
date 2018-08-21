# frozen_string_literal: true

FactoryBot.define do
  factory :home do
    name { Faker::Space.planet }
    owner
    home_type
    is_public { false }
    gateway_mac_address { nil }
  end

  factory :public_home, parent: :home do
    is_public { true }
  end

  factory :home_with_rooms, parent: :home do
    transient do
      rooms_count { 5 }
    end
    after(:create) do |home, evaluator|
      create_list(:room, evaluator.rooms_count, home: home)
    end
  end

  factory :home_with_sensors, parent: :home do
    transient do
      sensors_count { 5 }
    end
    after(:create) do |home, evaluator|
      create_list(:sensor, evaluator.sensors_count, home: home)
    end
  end
end
