# frozen_string_literal: true

class AddNodeIdNumberToSensors < ActiveRecord::Migration
  def change
    add_column(:sensors, :node_id, :integer)
  end
end
