FactoryGirl.define do
  factory :room do
    name { Faker::Hipster.word }
    home
    room_type

    transient do
      temperature nil
      humidity nil
      dewpoint nil
    end

    after(:create) do |room, evaluator|
      create(:temperature_reading, room: room, value: evaluator.temperature) unless evaluator.temperature.nil?
      create(:humidity_reading, room: room, value: evaluator.humidity) unless evaluator.humidity.nil?
      create(:dewpoint_reading, room: room, value: evaluator.dewpoint) unless evaluator.dewpoint.nil?
    end
  end

  factory :public_room, parent: :room do
    home { FactoryGirl.create(:public_home) }
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

  factory :room_with_sensors, parent: :room do
    sensors { create_list(:sensor_with_messages, 1, home: home) }
  end

  factory :room_with_min_max, parent: :room do
    room_type { create :room_type, min_temperature: 18, max_temperature: 28 }
  end

  factory :cold_room, parent: :room_with_min_max do
    readings { create_list(:temperature_reading, 1, value: 12.5) }
  end

  factory :ok_room, parent: :room_with_min_max do
    readings { create_list(:temperature_reading, 1, value: 20.5) }
  end

  factory :hot_room, parent: :room_with_min_max do
    readings { create_list(:temperature_reading, 1, value: 32.0) }
  end

  factory :healthy_room, parent: :room_with_min_max do
    readings do
      [
        create(:temperature_reading, value: 22.0),
        create(:humidity_reading, value: 45),
        create(:dewpoint_reading, value: 9)
      ]
    end
  end

  factory :damp_room, parent: :room_with_min_max do
    readings do
      [
        create(:temperature_reading, value: 19.0),
        create(:humidity_reading, value: 98),
        create(:dewpoint_reading, value: 21)
      ]
    end
  end
end
