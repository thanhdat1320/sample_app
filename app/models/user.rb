class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, :email, presence: true
  validates :password, length:
          {maximum: Settings.validations.length.digit_255,
           minimum: Settings.validations.length.digit_6}
  validates :email, uniqueness: true,
           length: {maximum: Settings.validations.length.digit_255,
                    minimum: Settings.validations.length.digit_6},
           format: {with: VALID_EMAIL_REGEX}
  has_secure_password
end
