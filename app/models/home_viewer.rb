# frozen_string_literal: true

class HomeViewer < ApplicationRecord
  belongs_to :user
  belongs_to :home

  validates :user, presence: true
  validates :home, presence: true
end
