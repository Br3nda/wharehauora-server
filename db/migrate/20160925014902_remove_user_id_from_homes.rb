# frozen_string_literal: true

class RemoveUserIdFromHomes < ActiveRecord::Migration[4.2]
  def change
    remove_column :homes, :user_id, :int
  end
end
