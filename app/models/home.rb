# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :sensors
  has_many :readings, through: :sensors
  belongs_to :owner
  belongs_to :home_type

  has_many :authorizedviewers, dependent: :destroy
  has_many :users, through: :authorizedviewers

  scope :is_public?, -> { where(is_public: true) }

#def add_authorized_viewer
#  Rails.logger.debug()
#  # @home.update(home_params)
#  # @home.save!
#  # edirect_to home_path(@home)
#end

end
