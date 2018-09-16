# frozen_string_literal: true

class AddIdealsToRoomType < ActiveRecord::Migration[4.2]
  def change
    add_column :room_types, :min_temperature, :float
    add_column :room_types, :max_temperature, :float
  end
end
