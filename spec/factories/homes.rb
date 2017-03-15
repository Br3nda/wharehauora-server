FactoryGirl.define do
  factory :home do
    name { Faker::Space.planet }
    owner
  end
end
