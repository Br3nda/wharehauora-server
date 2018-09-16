# frozen_string_literal: true

class MessageV2 < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :topic, :string
    add_column :sensors, :mac_address, :string
  end
end
