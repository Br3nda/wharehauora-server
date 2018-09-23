# frozen_string_literal: true

class RoomType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_many :rooms
end
