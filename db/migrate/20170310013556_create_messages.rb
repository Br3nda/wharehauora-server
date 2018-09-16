# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :messages do |t|
      t.integer  'node_id'
      t.string   'message_type'
      t.integer  'child_sensor_id'
      t.integer  'ack'
      t.integer  'sub_type'
      t.text     'payload'
      t.references :sensor
      t.timestamps null: false
    end
  end
end
