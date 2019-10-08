class User < ApplicationRecord
  has_secure_password
  validates :alias, :email, presence: true
  validates :alias, :email, uniqueness: true
  validates :password, confirmation: true, unless: -> { password.blank? }
  validates :admin_status, inclusion: { in: [true, false] }

  # has_many :characters
  # has_many :teams, through: :characters
  # has_many :battles, through: :characters
  #
  # has_many :plikes
  # has_many :powers, through: :plikes
  #
  # has_many :friends
  # has_many :users, through: :friends, as: :follows
  # has_many :users, through: :friends, as: :followers
end
