class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed # .following = .followeds

  has_many :passive_relationships, class_name: 'Relationship',
                                  foreign_key: 'followed_id',
                                  dependent: :destroy

  has_many :followers, through: :passive_relationships


  attr_accessor :remember_token, :activation_token, :reset_token # cookie : accessibilite du token sans le storer dans la DB
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  validates :activated, default: false
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Cryptage
  def self.digest(string) # cryptage
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
                                                : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # generate Token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def activated?
    activated
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_reset_password_email
    UserMailer.password_reset(self).deliver_now
  end

  # Remember-me / Authentication parameters
  def remember # creation d'un token, de remember_token et son cryptage = remember_digest
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    # ( :remember = 'remember', remember_token)
    # ( :activation = 'activation', activation_token)
    # ( :reset = 'reset', reset_token)
    digest = self.send("#{attribute}_digest") # egal  à   digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    self.update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where('user_id = ?', id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    other_user.following?(self)
  end

private
  # Activation parameters
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def downcase_email
    self.email.downcase!
  end
end
