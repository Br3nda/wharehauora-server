class HomesHaveOwners < ActiveRecord::Migration
  def change
    add_column :homes, :owner_id, :integer
    add_foreign_key :homes, :users, column: :owner_id
  end
end
