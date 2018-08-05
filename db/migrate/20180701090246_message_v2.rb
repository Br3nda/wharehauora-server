# frozen_string_literal: true

class MessageV2 < ActiveRecord::Migration
  def change
    add_column :messages, :topic, :string
    add_column :sensors, :mac_address, :string
  end
end
