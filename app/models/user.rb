class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  attr_accessor :remember_token
  validates :name, :email, presence: true
  validates :password, length:
          {maximum: Settings.validations.length.digit_255,
           minimum: Settings.validations.length.digit_6},
           allow_nil: true
  validates :email, uniqueness: true,
           length: {maximum: Settings.validations.length.digit_255,
                    minimum: Settings.validations.length.digit_6},
           format: {with: VALID_EMAIL_REGEX}
  has_secure_password

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
