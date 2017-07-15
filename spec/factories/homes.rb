FactoryGirl.define do
  factory :home do
    name { Faker::Space.planet }
    owner
    home_type
    is_public false
  end
end
