# frozen_string_literal: true

class CreateRoomTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :room_types do |t|
      t.text :name, null: false
      t.timestamps null: false
    end

    change_table :sensors do |t|
      t.references :room_type
    end
  end
end
