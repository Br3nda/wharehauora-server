# frozen_string_literal: true

class AddRoomNameToSensors < ActiveRecord::Migration
  def change
    add_column(:sensors, :room_name, :string)
  end
end
