class Reading < ActiveRecord::Base
  belongs_to :sensor
  delegate :home, :home_id, to: :room, allow_nil: false
  # scope :temperature, -> { where(sub_type: MySensors::SetReq::V_TEMP) }
  # scope :humidity, -> { where(sub_type: MySensors::SetReq::V_HUM) }

  validates :key, :value, :room, presence: true

  belongs_to :room
  scope :temperature, -> { where(key: 'temperature') }
  scope :humidity, -> { where(key: 'humidity') }
  scope :mould, -> { where(key: 'mould') }

  validates :key, :value, :room, presence: true

  def self.metrics_by_home_and_room(created_after)
    Reading.joins(:room, room: :home)
           .where('home_type_id IS NOT NULL AND room_type_id IS NOT NULL')
           .where('readings.created_at >= ?', created_after)
           .group('home_type_id', 'room_type_id')
  end
end
