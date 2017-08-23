# frozen_string_literal: true

class Invitation < ActiveRecord::Base
  belongs_to :home
  belongs_to :inviter, class_name: 'User'

  enum status: {
    pending: 'pending',
    accepted: 'accepted',
    declined: 'declined'
  }

  before_validation :generate_token, on: :create

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true

  def to_param
    token
  end

  private

  def generate_token
    while token.blank? || Invitation.where(token: token).exists?
      self.token = Devise.friendly_token[0, 40]
    end
  end
end
