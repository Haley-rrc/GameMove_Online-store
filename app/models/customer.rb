class Customer < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         authentication_keys: [:username]

  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :first_name,
            :last_name,
            :email,
            :address,
            :city,
            :postal_code,
            :province_id,
            presence: true

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  validates :postal_code,
            format: {
              with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
              message: "must be a valid Canadian postal code"
            }

  # Username is required only for registered accounts.
  validates :username,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            length: {
              minimum: 3,
              maximum: 30
            },
            if: :registered_account?

  # Password is required when creating or changing an account.
  validates :password,
            presence: true,
            length: { minimum: 6 },
            if: :account_password_required?

  private

  def registered_account?
    username.present? ||
      encrypted_password.present? ||
      password.present?
  end

  def account_password_required?
    username.present? &&
      (new_record? || password.present?)
  end
end