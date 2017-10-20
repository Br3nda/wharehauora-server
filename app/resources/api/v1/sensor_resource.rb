module Api
  module V1
    class SensorResource < ApplicationResource
      model_name 'Sensor'
      attribute :node_id
      has_one :home
      has_one :room
    end
  end
end
