class AddIdealsToRoomType < ActiveRecord::Migration
  def change
    add_column :room_types, :min_temperature, :float
    add_column :room_types, :max_temperature, :float
  end
end
