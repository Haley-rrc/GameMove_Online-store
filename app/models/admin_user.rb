class AdminUser < ApplicationRecord
  # Encrypts and checks the administrator password.
  has_secure_password

  # Username is required and cannot repeat.
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
end