class User < ApplicationRecord
  # makes remember_token available via user.remember_token (for storage in cookies) WITHOUT storing in database
  attr_accessor :remember_token

  # callback method to modify object attribute before saving to DB
  before_save { self.email = email.downcase }

  # also could have written assignment as:
  # self.email = self.email.downcase
  # inside User model, self keyword is optional

  # User is not valid without a name attribute
  # name cannot be blank (not "" or "    ")
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true

  # uniqueness: { case_sensitive: false } --> enforce uniqueness regardless of character case

  # Rails method has_secure_password
  # adds virtual attributes password and password_confirmation to User model
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random "remember me" token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  # associates a remember token with the user
  # saves the corresponding remember digest to the database
  def remember
    # self ensures you're setting user's remember_token attribute (as opposed to local var)
    self.remember_token = User.new_token
    # updates remember_digest attribute in backend
    # method bypasses validations
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    # if user logs in to app in two seperate browsers, then logs out in one browser, remember_digest is set to nil.
    # without this line, when the second browser is closed and reopened, cookies.signed[:user_id] still exists so
    # authenticated? would still be called and return an error because there's no remeber_digest
    return false if remember_digest.nil?
    # remember_token argument here is NOT the same as the accessor :remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  # undoes user.remember
  def forget
    update_attribute(:remember_digest, nil)
  end
end
