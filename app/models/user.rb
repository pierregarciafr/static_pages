class User < ApplicationRecord
  attr_accessor :remember_token # cookie : accessibilite du token sans le storer dans la DB

  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember # on place dans la colonne remember_digest le token crypté
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token) # different de self.remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # par contre remember_digest est bien celui de l'instance)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
