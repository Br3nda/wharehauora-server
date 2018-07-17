# frozen_string_literal: true

class RemoveUserIdFromHomes < ActiveRecord::Migration
  def change
    remove_column :homes, :user_id, :int
  end
end
