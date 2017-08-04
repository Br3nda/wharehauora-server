module Api
  module V1
    class HomeResource < ApplicationResource
      model_name 'Home'
      attribute :name
    end
  end
end
