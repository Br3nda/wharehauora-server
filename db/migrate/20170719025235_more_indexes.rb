# frozen_string_literal: true

class MoreIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :readings, :key
    add_index :readings, %i[key room_id]
    add_index :readings, :created_at
    add_index :messages, :created_at
    add_index :homes, :is_public
  end
end
