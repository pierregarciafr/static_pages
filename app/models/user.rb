class User < ApplicationRecord
  attr_accessor :remember_token # cookie : accessibilite du token sans le storer dans la DB
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  def self.digest(string) # cryptage
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember # creation d'un token, de remember_token et son cryptage = remember_digest
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
