# frozen_string_literal: true
class Home < ActiveRecord::Base
  belongs_to :owner
  belongs_to :home_type

  has_many :rooms
  # has_many :readings, through: :sensors

  has_many :sensors, through: :rooms
  has_many :home_viewers
  has_many :users, through: :home_viewers

  scope :is_public?, -> { where(is_public: true) }

  validates :name, presence: true

  def find_or_create_sensor(node_id)
    sensor = Sensor
             .where('room_id in (SELECT room_id FROM rooms WHERE home_id=?)', id)
             .find_by(node_id: node_id)
    unless sensor
      room = Room.create!(name: 'New sensor detected', home: self)
      sensor = Sensor.create!(node_id: node_id, room: room)
    end
    sensor
  end
end
