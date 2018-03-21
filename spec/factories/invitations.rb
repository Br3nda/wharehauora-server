FactoryBot.define do
  factory :invitation do
    home
    inviter { home.owner }
    email { Faker::Internet.email }
  end
end
