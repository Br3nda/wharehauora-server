class AddDeletedToRoomsAndHomes < ActiveRecord::Migration
  def change
    add_column :rooms, :deleted_at, :datetime
    add_column :homes, :deleted_at, :datetime
    add_index :rooms, :deleted_at
    add_index :homes, :deleted_at
  end
end
