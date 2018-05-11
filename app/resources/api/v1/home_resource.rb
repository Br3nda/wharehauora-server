module Api
  module V1
    class HomeResource < ApplicationResource
      model_name 'Home'
      attribute :name
      has_many :rooms
      has_many :sensors
      has_many :users
      has_one :owner, class_name: 'User'

      included :users
    end
  end
end
