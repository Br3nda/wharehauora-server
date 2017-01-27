class RemoveRooms < ActiveRecord::Migration
  def change
    remove_column :sensors, :room_id, :int
  end
end
