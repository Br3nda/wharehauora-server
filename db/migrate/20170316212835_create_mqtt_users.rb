# frozen_string_literal: true

class CreateMqttUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :mqtt_users do |t|
      t.references :user
      t.string :username
      t.string :password
      t.timestamp :provisioned_at
      t.timestamps null: false
    end
    add_foreign_key :mqtt_users, :users
  end
end
