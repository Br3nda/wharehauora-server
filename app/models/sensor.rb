# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :room
  has_many :readings

  delegate :home, :home_id, to: :room, allow_nil: false
end
