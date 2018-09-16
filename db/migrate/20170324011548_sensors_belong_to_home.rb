# frozen_string_literal: true

class SensorsBelongToHome < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :home_id, :int
    Sensor.all.each do |sensor|
      sensor.home = sensor.room.home
      sensor.save!
    end
    change_column :sensors, :home_id, :int, null: false
    add_foreign_key :sensors, :homes

    # allow a sensor to be not assigned to a room
    change_column :sensors, :room_id, :int, null: true
  end
end
