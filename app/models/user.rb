class User < ApplicationRecord
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
end
