FactoryBot.define do
  factory :sensor do
    node_id { rand 100..999 }
    mac_address { node_id }
    home
  end

  factory :sensor_with_messages, parent: :sensor do
    transient do
      messages_count 250
    end
    after(:create) do |sensor, evaluator|
      create_list(:message, evaluator.messages_count, sensor: sensor)
    end
  end
end
