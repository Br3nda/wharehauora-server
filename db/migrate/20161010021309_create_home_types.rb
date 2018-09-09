# frozen_string_literal: true

class CreateHomeTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :home_types do |t|
      t.text :name, null: false
      t.timestamps null: false
    end
    change_table :homes do |t|
      t.references :home_type
    end
  end
end
