# frozen_string_literal: true

class CreateSensors < ActiveRecord::Migration[4.2]
  def change
    create_table :sensors do |t|
      t.references :room
      t.string :name
      t.timestamps null: false
    end
  end
end
