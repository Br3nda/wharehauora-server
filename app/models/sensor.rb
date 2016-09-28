# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :room
  belongs_to :home
  has_many :readings

  # delegate :home, :home_id, to: :room, allow_nil: false
end
