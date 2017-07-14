FactoryGirl.define do
  factory :sensor do
    node_id { rand 100..999 }
    home
  end
end
