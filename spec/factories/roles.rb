# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name { 'roleyrole' }
    friendly_name { 'Friend' }
  end
  factory :janitor, class: Role do
    name { 'janitor' }
    friendly_name { 'cleans up' }
  end
end
