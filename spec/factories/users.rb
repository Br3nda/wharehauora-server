FactoryBot.define do
  factory :user, aliases: [:owner] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    after(:create) do |user, _evaluator|
      user.confirm
    end
  end
  factory :admin, parent: :user do
    roles { [FactoryBot.create(:janitor)] }
  end
end
