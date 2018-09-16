# frozen_string_literal: true

class RoomSensorsCount < ActiveRecord::Migration[4.2]
  def change
    add_column :rooms, :sensors_count, :integer, default: 0
    Room.find_each do |room|
      Room.reset_counters(room.id, :sensors)
    end
  end
end
