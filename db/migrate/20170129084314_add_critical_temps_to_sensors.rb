class AddCriticalTempsToSensors < ActiveRecord::Migration
  def change
    create_table :suburbs do |t|
      t.text :name
      t.text :weather_station
    end
    change_table :homes do |t|
      t.integer :suburb_id
    end
    add_foreign_key :homes, :suburbs

    create_table :weather_condition do |t|
      t.integer :suburb_id
      t.float :outdoor_temperature
      t.float :outdoor_humidity
      t.timestamps null: false
    end
    add_foreign_key :weather_condition, :suburbs

    create_table :metrics do |t|
      t.integer :sensor_id
      t.float :indoor_temperature
      t.float :outdoor_temperature
      t.float :indoor_humidity
      t.float :dewpoint
      t.float :mold_indicator
      t.timestamps null: false
    end
    add_foreign_key :metrics, :sensors
  end
end
