class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :room_id, null: false
      t.text :key
      t.float :value
      t.timestamps null: false
    end
    add_foreign_key :metrics, :rooms

    add_column :rooms, :room_type_id, :integer
    add_foreign_key :rooms, :room_types
  end
end
