class RenameMetricsToReadings < ActiveRecord::Migration
  def up
    rename_table :readings, :old_readings

    create_table :readings do |t|
      t.integer :room_id, null: false
      t.text :key
      t.float :value
      t.timestamps null: false
    end
    add_foreign_key :readings, :rooms
  end

  def down
    drop_table :readings
    rename :old_readings, :readings
  end
end
