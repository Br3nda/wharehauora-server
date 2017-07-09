# frozen_string_literal: true

class Sensor < ActiveRecord::Base
  belongs_to :home, counter_cache: true
  validates :home, presence: true

  belongs_to :room

  has_many :messages

  delegate :home_type, to: :home
  delegate :room_type, to: :room

  scope(:joins_home, -> { joins(:room, room: :home) })
  scope(:with_no_messages, -> { includes(:messages).where(messages: { id: nil }) })

  def last_message
    messages.order(created_at: :desc).first.created_at
  end
end
