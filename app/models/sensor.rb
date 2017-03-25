# frozen_string_literal: true
class Sensor < ActiveRecord::Base
  belongs_to :home
  validates :home, presence: true

  belongs_to :room

  has_many :messages

  delegate :home_type, to: :hoom
  delegate :room_type, to: :room

  scope :joins_home, -> { joins(:room, room: :home) }
  scope :without_messages, -> { includes(:messages).where(messages: { id: nil }) }
end
