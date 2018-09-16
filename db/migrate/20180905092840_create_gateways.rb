# frozen_string_literal: true

class CreateGateways < ActiveRecord::Migration[4.2]
  def change
    create_table :gateways do |t|
      t.text :mac_address
      t.text :version
      t.timestamps null: false
    end
  end
end
