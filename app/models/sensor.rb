# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :home
  has_many :readings

  def temperature
    Reading.find_by(sensor: self, sub_type: V_TEMP).value
  end

  def humidity
    Reading.find_by(sensor_id: id, sub_type: V_HUM).value
  end

  V_TEMP = 0
  V_HUM = 1
end
