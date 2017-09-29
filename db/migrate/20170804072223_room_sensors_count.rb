class RoomSensorsCount < ActiveRecord::Migration
  def change
    add_column :rooms, :sensors_count, :integer, default: 0
    Room.unscoped.find_each do |room|
      Room.reset_counters(room.id, :sensors)
    end
  end
end
