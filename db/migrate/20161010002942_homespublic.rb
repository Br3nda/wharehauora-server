# frozen_string_literal: true

class Homespublic < ActiveRecord::Migration[4.2]
  def change
    add_column :homes, :is_public, :boolean, default: false
  end
end
