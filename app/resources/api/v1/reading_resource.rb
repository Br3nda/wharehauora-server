# frozen_string_literal: true

module Api
  module V1
    class ReadingResource < ApplicationResource
      immutable
      model_name 'Reading'
      attribute :key
      attribute :value
      attribute :created_at
    end
  end
end
