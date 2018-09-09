# frozen_string_literal: true

class DeleteInvitations < ActiveRecord::Migration[4.2]
  def change
    drop_table :invitations
  end
end
