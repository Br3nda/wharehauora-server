# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[4.2]
  def change
    create_table :invitations do |t|
      t.belongs_to :inviter, null: false, references: :users
      t.belongs_to :home, null: false
      t.string :token, limit: 40, null: false, index: true
      t.string :email
      t.string :status, limit: 16, null: false, default: 'pending'
      t.timestamps null: false
    end
  end
end
