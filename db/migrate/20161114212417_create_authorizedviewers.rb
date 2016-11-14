class CreateAuthorizedviewers < ActiveRecord::Migration
  def change
    create_table :authorizedviewers do |t|
      t.integer :user_id
      t.integer :home_id

      t.timestamps null: false
    end

    add_foreign_key :authorizedviewers, :users
    add_foreign_key :authorizedviewers, :homes
  end
end
