# frozen_string_literal: true

class RoomType < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :rooms
end
