# frozen_string_literal: true

class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :user, presence: true
  validates :role, presence: true
end
