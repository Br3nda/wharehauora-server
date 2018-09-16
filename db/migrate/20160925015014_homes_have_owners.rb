# frozen_string_literal: true

class HomesHaveOwners < ActiveRecord::Migration[4.2]
  def change
    add_column :homes, :owner_id, :integer
    add_foreign_key :homes, :users, column: :owner_id
  end
end
