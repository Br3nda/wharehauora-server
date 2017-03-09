# frozen_string_literal: true
class Api::HomeResource < JSONAPI::Resource
  attributes :name
  belongs_to :owner
end
