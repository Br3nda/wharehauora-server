FactoryGirl.define do
  factory :room do
    name { Faker::Hipster.word }
    home
    room_type
  end

  factory :public_room, parent: :room do
    home { FactoryGirl.create(:public_home) }
  end

  factory :room_with_readings, parent: :room do
    after(:create) do |room|
      create_list(:temperature_reading, 100, room: room)
    end
  end

  factory :public_room_with_readings, parent: :public_room do
    after(:create) do |room|
      create_list(:temperature_reading, 100, room: room, created_at: 5.minutes.ago)
    end
  end
end
