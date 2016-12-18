FactoryGirl.define do
  factory :home_type do
    name { Faker::Space.planet }
  end
end
