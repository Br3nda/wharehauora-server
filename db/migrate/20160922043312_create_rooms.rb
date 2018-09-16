# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[4.2]
  def change
    create_table :rooms do |t|
      t.references :home
      t.text :name
      t.timestamps null: false
    end
  end
end
