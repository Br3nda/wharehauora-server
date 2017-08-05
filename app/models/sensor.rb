# frozen_string_literal: true

class Sensor < ActiveRecord::Base
  belongs_to :home
  validates :home, presence: true
  validate :same_home_as_room

  belongs_to :room, counter_cache: true

  has_many :messages, dependent: :destroy

  delegate :home_type, to: :home
  delegate :room_type, to: :room

  scope(:joins_home, -> { joins(:room, room: :home) })
  scope(:with_no_messages, -> { includes(:messages).where(messages: { id: nil }) })

  def last_message
    messages.order(created_at: :desc).first.created_at
  end

  def same_home_as_room
    return true if room_id.blank?
    room.home_id == home_id
  end
end
