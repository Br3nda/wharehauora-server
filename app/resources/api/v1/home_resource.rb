module Api
  module V1
    class HomeResource < ApplicationResource
      model_name 'Home'
      attribute :name
      has_many :rooms
      has_many :sensors
    end
  end
end
