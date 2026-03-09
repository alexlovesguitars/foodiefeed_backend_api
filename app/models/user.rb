class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :recipes, dependent: :destroy
  has_many :cookbooks, dependent: :destroy
  has_many :messages
  has_many :conversations, through: :messages



  validates :email, presence: true, uniqueness: true
end
