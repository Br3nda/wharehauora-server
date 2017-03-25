FactoryGirl.define do
  factory :sensor do
    node_id { Faker::Number }
    room
    home
  end
end
