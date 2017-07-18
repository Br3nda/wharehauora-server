class Reading < ActiveRecord::Base
  belongs_to :room, counter_cache: true

  delegate :home, :home_id, :home_type, to: :room, allow_nil: false
  delegate :room_type, to: :room, allow_nil: false

  validates :key, :value, :room, presence: true

  scope(:joins_home, -> { joins(:room, room: :home) })

  scope(:temperature, -> { where(key: 'temperature') })
  scope(:humidity, -> { where(key: 'humidity') })
  scope(:mould, -> { where(key: 'mould') })
  scope(:dewpoint, -> { where(key: 'dewpoint') })
  scope(:normal_range, -> { where('value < 100 AND value > -5') })
  validates :key, :value, :room, presence: true

  def too_cold?
    return unless room && room.room_type && room.room_type.min_temperature
    value < room.room_type.min_temperature
  end

  def unit
    MeasurementsUnitsService.unit_for(key)
  end

  def current?
    created_at > 1.hour.ago
  end
end
