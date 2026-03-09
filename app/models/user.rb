class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :recipes, dependent: :destroy
  has_many :cookbooks, dependent: :destroy
  has_many :messages
  has_many :conversations, through: :messages

  enum :role, {
    user: 0,
    creator: 1,
    admin: 2
  }

  validates :username, presence: true
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
end
