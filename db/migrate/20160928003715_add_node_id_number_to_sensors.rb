# frozen_string_literal: true

class AddNodeIdNumberToSensors < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :node_id, :integer
  end
end
