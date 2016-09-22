# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :room
end
