# frozen_string_literal: true

module Api
  module V1
    class ApplicationResource < JSONAPI::Resource
      include Pundit::Resource
    end
  end
end
