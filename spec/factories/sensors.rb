FactoryGirl.define do
  factory :sensor do
    node_id { Faker::Number }
    room
  end
end
