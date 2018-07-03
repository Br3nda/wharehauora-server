# frozen_string_literal: true

module Api
  module V1
    class HomeResource < ApplicationResource
      model_name 'Home'
      attributes :name, :home_type, :home_type_id, :owner_id, :gateway_mac_address

      has_many :rooms
      has_many :sensors
      has_many :users
      has_one :owner, class_name: 'User'
      has_one :home_type

      filters :owner_id, :home_type_id

      before_save do
        @model.owner_id = current_user.id if @model.new_record?
      end
    end
  end
end
