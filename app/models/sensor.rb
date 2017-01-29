# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :home
  belongs_to :room_type
  has_many :readings
  has_many :metrics

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
