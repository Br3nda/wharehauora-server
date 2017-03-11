class MigrateReadings < ActiveRecord::Migration
  def up
    add_column :rooms, :room_type_id, :integer
    add_foreign_key :rooms, :room_types

    # Migrate existing data
    Sensor.all.each do |sensor|

      room_name = if sensor.room_name
                    sensor.room_name
                  else
                    "new room"
                  end

      room = Room.new
      room.home_id = sensor.home_id
      room.name = room_name
      room.room_type_id = sensor.room_type_id
      room.save!

      sensor.room = room
      sensor.save!
    end

    rename_table :readings, :old_readings

    create_table :readings do |t|
      t.integer :room_id, null: false
      t.text :key
      t.float :value
      t.timestamps null: false
    end
    add_foreign_key :readings, :rooms


    OldReading.all.each do |old_reading|
      reading = Reading.new
      reading.room = old_reading.sensor.room
      reading.value = old_reading.value
      reading.key = case old_reading.sub_type
                    when MySensors::SetReq::V_TEMP
                      "temperature"
                    when MySensors::SetReq::V_HUM
                      "humidity"
                    else
                      "unknown"
                    end
      reading.save!
    end
    remove_column :sensors, :room_type_id
    remove_column :sensors, :home_id
    remove_column :sensors, :room_name
    remove_column :sensors, :name
  end

  def down
    drop_table :readings
    rename :old_readings, :readings

    add_column :sensors, :room_type_id, :integer
    add_column :sensors, :home_id, :integer
    add_column :sensors, :room_name, :text
    add_column :sensors, :name, :text

    Sensor.all do |s|
      Sensor.update!(home: s.room.home, room_name: s.room.name, room_type: s.room.room_type)
    end

  end

  class OldReading < ActiveRecord::Base
    belongs_to :sensor
    # belongs_to :home, through: :sensor
    # t.integer  "sensor_id"
    # t.text     "key"
    # t.float    "value"
    # t.datetime "created_at",      null: false
    # t.datetime "updated_at",      null: false
    # t.string   "message_type"
    # t.integer  "child_sensor_id"
    # t.integer  "ack"
    # t.integer  "sub_type"
  end
end
