# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :room
  has_many :readings

  delegate :room_type, to: :room
  delegate :home, to: :room
  delegate :home_type, to: :room

  def temperature
    Reading.where(sensor: self, sub_type: MySensors::SetReq::V_TEMP)
           .order(created_at: :desc)
           .first
           .value
  rescue
    nil
  end

  def humidity
    Reading.where(sensor_id: id, sub_type: MySensors::SetReq::V_HUM)
           .order(created_at: :desc)
           .first
           .value
  rescue
    nil
  end

  def last_reading
    Reading.where(sensor_id: id)
           .order(created_at: :desc)
           .first
           .created_at
  rescue
    nil
  end

  def rating; end
end
