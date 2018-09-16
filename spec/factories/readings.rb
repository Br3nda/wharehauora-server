# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    room
    key { 'temperature' }
    value { 21.2 }
  end

  factory :temperature_reading, parent: :reading do
    key { 'temperature' }
  end
  factory :humidity_reading, parent: :reading do
    key { 'humidity' }
  end
  factory :dewpoint_reading, parent: :reading do
    key { 'dewpoint' }
  end
end
