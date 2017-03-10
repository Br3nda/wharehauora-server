# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :room
  has_many :messages

  delegate :room_type, to: :room
  delegate :home, to: :room
  delegate :home_type, to: :hoom

  validates :room, presence: true

  scope :joins_home, -> { joins(:room, room: :home) }

  def last_message
    Message.where(sensor_id: id)
           .order(created_at: :desc)
           .first
           .created_at
  rescue
    nil
  end
end
