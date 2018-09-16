# frozen_string_literal: true

class AddHomeAndMessageTypeToSensors < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :home_id, :integer
    add_column :readings, :message_type, :string
  end
end
