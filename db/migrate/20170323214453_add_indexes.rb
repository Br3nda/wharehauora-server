# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :homes, :name
    add_index :homes, :owner_id
    add_index :rooms, :home_id
    add_index :rooms, :name
    add_index :readings, :room_id
    add_index :sensors, :node_id
    add_index :messages, :sensor_id
  end
end
