FactoryGirl.define do
  factory :user, aliases: [:owner] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
  factory :admin, parent: :user do
    roles { [FactoryGirl.create(:janitor)] }
  end
end
