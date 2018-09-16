# frozen_string_literal: true

class CounterCaches < ActiveRecord::Migration[4.2]
  def change
    add_column :homes, :rooms_count, :integer
    add_column :homes, :sensors_count, :integer

    Home.find_each do |home|
      Home.reset_counters(home.id, :rooms)
      Home.reset_counters(home.id, :sensors)
    end

    add_column :rooms, :readings_count, :integer
    Room.find_each do |room|
      Room.reset_counters(room.id, :readings)
    end

    add_column :sensors, :messages_count, :integer
    Sensor.find_each do |sensor|
      Sensor.reset_counters(sensor.id, :messages)
    end
  end
end
