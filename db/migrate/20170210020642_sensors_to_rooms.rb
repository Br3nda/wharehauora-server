class SensorsToRooms < ActiveRecord::Migration
  def up
    # Migrate existing data
    Sensor.all do |s|
      Room.create!(home: s.home, name: s.name, room_type: s.room_type)
    end
    remove_column :sensors, :room_type_id
    remove_column :sensors, :home_id
    remove_column :sensors, :room_name
    remove_column :sensors, :name
  end

  def down
    add_column :sensors, :room_type_id, :integer
    add_column :sensors, :home_id, :integer
    add_column :sensors, :room_name, :text
    add_column :sensors, :name, :text

    Sensor.all do |s|
      Sensor.update!(home: s.room.home, room_name: s.room.name, room_type: s.room.room_type)
    end
  end
end
