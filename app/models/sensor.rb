# frozen_string_literal: true

class Sensor < ApplicationRecord
  before_create :create_room
  belongs_to :home, counter_cache: true
  validates :home, presence: true
  validate :same_home_as_room
  validates :mac_address, uniqueness: true, allow_nil: true

  belongs_to :room, counter_cache: true, optional: true

  has_many :messages, dependent: :destroy

  delegate :home_type, to: :home
  delegate :room_type, to: :room

  scope(:joins_home, -> { joins(:room, room: :home) })
  scope(:with_no_messages, -> { includes(:messages).where(messages: { id: nil }) })

  def last_message
    messages.order(created_at: :desc).first&.created_at
  end

  def same_home_as_room
    return true if room_id.blank?

    room.home_id == home_id
  end

  private

  def create_room
    self.room = Room.create!(name: '{mac_address}{node_id}', home: home) if room_id.blank?
  end
end
