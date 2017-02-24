class Reading < ActiveRecord::Base
  belongs_to :sensor
  delegate :home, :home_id, to: :sensor, allow_nil: false
  scope :temperature, -> { where(sub_type: MySensors::SetReq::V_TEMP) }
  scope :humidity, -> { where(sub_type: MySensors::SetReq::V_HUM) }

  scope :joins_home, -> { joins(:sensor, sensor: [:room, room: :home]) }

  def self.readings_by_home_and_room(created_after)
    Reading.joins(:sensor, sensor: :room).joins('INNER JOIN homes ON rooms.home_id=homes.id')
           .where('home_type_id IS NOT NULL AND room_type_id IS NOT NULL')
           .where('readings.created_at >= ?', created_after)
           .group('home_type_id', 'room_type_id')
  end
end
