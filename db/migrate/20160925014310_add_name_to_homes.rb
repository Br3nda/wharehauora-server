# frozen_string_literal: true

class AddNameToHomes < ActiveRecord::Migration[4.2]
  def change
    add_column :homes, :name, :string
  end
end
