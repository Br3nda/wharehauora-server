class CreateHomeTypes < ActiveRecord::Migration
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
