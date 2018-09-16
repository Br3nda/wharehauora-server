# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :friendly_name, null: false
      t.timestamps null: false
    end

    add_index :roles, :name, unique: true

    create_table :user_roles do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :role, index: true, null: false
      t.timestamps null: false
    end
  end
end
