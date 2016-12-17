class CreateHomeViewers < ActiveRecord::Migration
  def change
    create_table :home_viewers, id: false do |t|
      t.integer :user_id
      t.integer :home_id
      t.timestamps null: false
    end
    execute %Q{ ALTER TABLE "home_viewers" ADD PRIMARY KEY (user_id, home_id); }
    add_foreign_key :home_viewers, :users
    add_foreign_key :home_viewers, :homes
  end
end
