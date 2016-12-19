class Reading < ActiveRecord::Base
  belongs_to :sensor
  delegate :home, :home_id, to: :sensor, allow_nil: false
  scope :temperature, -> { where(sub_type: MySensors::SetReq::V_TEMP) }
  scope :humidity, -> { where(sub_type: MySensors::SetReq::V_HUM) }

  def self.readings_by_home_and_room(created_after)
    Reading.joins(:sensor, sensor: :home)
           .where('readings.created_at >= ?', created_after)
           .group('home_type_id', 'room_type_id')
  end
end
