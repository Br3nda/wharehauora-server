# frozen_string_literal: true

class AddGatewayMacToHome < ActiveRecord::Migration[4.2]
  def change
    add_column :homes, :gateway_mac_address, :string
  end
end
