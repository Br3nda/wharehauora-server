# frozen_string_literal: true

class AddHomeAndMessageTypeToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :home_id, :integer
    add_column :readings, :message_type, :string
  end
end
