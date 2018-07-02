FactoryBot.define do
  factory :sensor do
    mac_address { node_id }
    home
    node_id
    sequence(:node_id, 10)
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
