# frozen_string_literal: true

class CreateReadings < ActiveRecord::Migration[4.2]
  def change
    create_table :readings do |t|
      t.references :sensor
      t.text :key
      t.float :value
      t.timestamps null: false
    end
  end
end
