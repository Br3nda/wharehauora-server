# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :email, presence: true
  validate :no_deleted_account_exists

  has_many :user_roles
  has_many :roles, through: :user_roles

  has_one :mqtt_user

  has_many :home_viewers, dependent: :destroy
  has_many :viewable_homes, class_name: 'Home', source: :home, through: :home_viewers
  has_many :owned_homes, class_name: 'Home', foreign_key: :owner_id

  acts_as_paranoid # soft deletes, sets deleted_at column

  def no_deleted_account_exists
    return unless User.only_deleted.where(email: email).size.positive?

    errors.add(:email, 'already exists as a deleted account')
  end

  def homes
    owned_homes + viewable_homes
  end

  def role?(role)
    roles.any? { |r| r.name == role }
  end

  def janitor?
    role? 'janitor'
  end
end
