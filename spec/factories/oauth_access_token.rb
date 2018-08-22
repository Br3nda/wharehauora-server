# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_token, class: Doorkeeper::AccessToken do
    sequence(:resource_owner_id) { |n| n }
    association :application, factory: :oauth_application
    expires_in { 2.hours }
  end
end
