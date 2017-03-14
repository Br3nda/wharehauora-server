class Reading < ActiveRecord::Base
  belongs_to :room

  delegate :home, :home_id, to: :room, allow_nil: false

  scope :joins_home, -> { joins(:room, room: :home) }

  validates :key, :value, :room, presence: true

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
