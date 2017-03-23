FactoryGirl.define do
  factory :home do
    name { Faker::Space.planet }
    owner
    home_type
  end
end
