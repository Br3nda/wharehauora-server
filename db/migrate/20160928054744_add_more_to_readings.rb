class AddMoreToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :child_sensor_id, :integer
    add_column :readings, :ack, :integer
    add_column :readings, :sub_type, :integer
  end
end
