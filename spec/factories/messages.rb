# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    sensor
    node_id { rand(999) }
    child_sensor_id { rand(2) }
    message_type { rand(2) }
    ack { 0 }
    sub_type { 0 }
  end
end
