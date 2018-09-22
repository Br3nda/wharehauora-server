# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    name { Faker::Hipster.word }
    home
    room_type

    transient do
      temperature { nil }
      humidity { nil }
      dewpoint { nil }
    end

    after(:create) do |room, evaluator|
      create(:temperature_reading, room: room, value: evaluator.temperature) unless evaluator.temperature.nil?
      create(:humidity_reading, room: room, value: evaluator.humidity) unless evaluator.humidity.nil?
      create(:dewpoint_reading, room: room, value: evaluator.dewpoint) unless evaluator.dewpoint.nil?
    end
  end

  factory :room_with_type, parent: :room do
    room_type { FactoryBot.create(:room_type, min_temperature: 10, max_temperature: 30) }
  end

  factory :public_room, parent: :room do
    home { FactoryBot.create(:public_home) }
  end

  factory :room_with_readings, parent: :room do
    after(:create) do |room|
      create_list(:temperature_reading, 100,
                  room: room, created_at: 2.minutes.ago)
    end
  end

  factory :public_room_with_readings, parent: :public_room do
    after(:create) do |room|
      create_list(:temperature_reading, 100,
                  room: room, created_at: 5.minutes.ago)
    end
  end

  factory :room_with_sensors, parent: :room do |_room|
    after(:create) do |room|
      create_list(:sensor, 1, home: room.home, room: room)
    end
  end
end
