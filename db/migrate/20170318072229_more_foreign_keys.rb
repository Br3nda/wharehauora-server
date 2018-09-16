# frozen_string_literal: true

class MoreForeignKeys < ActiveRecord::Migration[4.2]
  def change
    # Homes table
    add_foreign_key :homes, :home_types
    change_column :homes, :owner_id, :int, null: false
    change_column :homes, :name, :text, null: false
    change_column :homes, :is_public, :boolean, null: false

    # Rooms
    add_foreign_key :sensors, :rooms
    change_column :rooms, :home_id, :int, null: false

    # Sensors
    add_foreign_key :messages, :sensors
    change_column :sensors, :room_id, :int, null: false
    change_column :sensors, :node_id, :int, null: false

    # Readings
    change_column :readings, :room_id, :int, null: false
    change_column :readings, :key, :text, null: false
    change_column :readings, :value, :float, null: false
  end
end
