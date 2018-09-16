# frozen_string_literal: true

class LinkMqttUserToHome < ActiveRecord::Migration[4.2]
  def change
    add_column :mqtt_users, :home_id, :integer
    add_foreign_key :mqtt_users, :homes
  end
end
