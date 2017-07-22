# frozen_string_literal: true

class Home < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :home_type

  has_many :rooms
  has_many :messages, through: :sensors

  has_many :sensors
  has_many :readings, through: :rooms

  has_many :home_viewers

  has_many :users, through: :home_viewers

  scope(:is_public?, -> { where(is_public: true) })

  validates :name, presence: true
  validates :owner, presence: true

  def find_or_create_sensor(node_id)
    sensor = sensors.find_by(node_id: node_id)
    sensor = Sensor.create!(home_id: id, node_id: node_id) unless sensor
    sensor
  end
end
