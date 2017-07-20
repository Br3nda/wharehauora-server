FactoryGirl.define do
  factory :user, aliases: [:owner] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
  factory :admin, class: User do
    roles { FactoryGirl.create :janitor }
  end
end
