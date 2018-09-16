# frozen_string_literal: true

class CreateHomeViewers < ActiveRecord::Migration[4.2]
  def change
    create_table :home_viewers do |t|
      t.integer :user_id
      t.integer :home_id
      t.timestamps null: false
    end
    add_foreign_key :home_viewers, :users
    add_foreign_key :home_viewers, :homes
    add_index :home_viewers, %i[user_id home_id], unique: true
  end
end
