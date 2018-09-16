# frozen_string_literal: true

class MigrateReadings < ActiveRecord::Migration[4.2]
  def up
    remove_orphaned_sensor_records
    add_column :rooms, :room_type_id, :integer
    add_foreign_key :rooms, :room_types
    migrate_sensor_records

    rename_table :readings, :old_readings

    create_table :readings do |t|
      t.integer :room_id, null: false
      t.text :key
      t.float :value
      t.timestamps null: false
    end

    add_foreign_key :readings, :rooms

    migrate_reading_records
    remove_column :sensors, :room_type_id
    remove_column :sensors, :home_id
    remove_column :sensors, :room_name
    remove_column :sensors, :name
  end

  def remove_orphaned_sensor_records
    newest_home = Home.all.order(:id).last
    return unless newest_home

    sensors = Sensor.where('home_id > ?', newest_home.id)
    sensors.delete_all if sensors.count
  end

  def migrate_sensor_records
    orphaned_query = 'home_id IS NULL OR home_id NOT IN (SELECT id FROM homes)'
    Sensor.where(orphaned_query).delete_all
    Room.where(orphaned_query).delete_all

    # Migrate existing data
    Sensor.all.each do |sensor|
      room_name = sensor.room_name || 'new room'
      room = Room.new
      room.home_id = sensor.home_id
      room.name = room_name
      room.room_type_id = sensor.room_type_id
      room.save!

      sensor.room = room
      sensor.save!
    end
  end

  def migrate_reading_records
    OldReading.where('sensor_id IS NULL OR sensor_id NOT IN (SELECT id FROM sensors)').delete_all
    count = OldReading.count
    num_per_batch = 500
    batches = count / num_per_batch

    for batch in 0..batches
      say "Converting readings, batch #{batch} of #{batches}"
      OldReading.where('value IS NULL').delete_all
      OldReading.limit(num_per_batch).offset(batch).each do |old_reading|
        reading = Reading.new
        reading.room = old_reading.sensor.room
        reading.value = old_reading.value
        reading.key = case old_reading.sub_type
                      when MySensors::SetReq::V_TEMP
                        'temperature'
                      when MySensors::SetReq::V_HUM
                        'humidity'
                      else
                        'unknown'
                      end
        # say reading
        reading.save!
      end
    end
    OldReading.delete_all
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

  class OldReading < ApplicationRecord
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
