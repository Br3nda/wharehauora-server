# frozen_string_literal: true

class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.references(:user)
      t.timestamps(null: false)
    end
  end
end
