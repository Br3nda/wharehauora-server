FactoryGirl.define do
  factory :room_type do
    name { Faker::Name.unique.name }
  end
end
