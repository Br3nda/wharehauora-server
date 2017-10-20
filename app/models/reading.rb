class Reading < ActiveRecord::Base
  belongs_to :room, counter_cache: true, touch: true

  delegate :home, :home_id, :home_type, to: :room, allow_nil: false
  delegate :room_type, to: :room, allow_nil: false

  validates :key, :value, :room, presence: true

  scope(:joins_home, -> { joins(:room, room: :home) })

  scope :by_key, ->(key) { where(key: key) }

  scope(:temperature, -> { by_key 'temperature' })
  scope(:humidity, -> { by_key 'humidity' })
  scope(:mould, -> { by_key 'mould' })
  scope(:dewpoint, -> { by_key 'dewpoint' })
  scope(:normal_range, -> { where('value < 100 AND value > -5') })

  def too_cold?
    return unless room && room.room_type && room.room_type.min_temperature
    value < room.room_type.min_temperature
  end

  def unit
    UnitsService.unit_for(key)
  end

  def current?
    created_at > 1.hour.ago
  end
end
