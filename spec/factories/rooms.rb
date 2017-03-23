FactoryGirl.define do
  factory :room do
    name { Faker::Hipster.word }
    home
    room_type
  end
end
