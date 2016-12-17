class RoomType < ActiveRecord::Base
  validates :name, uniqueness: true
end
