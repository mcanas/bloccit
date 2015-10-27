class User < ActiveRecord::Base
  has_many :posts

  before_save { self.email = email.downcase }
  before_save { self.name = self.name.split.map!{|n| n.capitalize}.join(' ') if self.name }
  before_save { self.role ||= :member }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  NAME_REGEX = /\A[A-Z]\w+(\s[A-Z]\w+)?\z/

  validates :name, length: { minimum: 1, maximum: 100 }, format: { with: NAME_REGEX }, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: 'password_digest.nil?'
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 100 },
            format: { with: EMAIL_REGEX }

  has_secure_password

  enum role: [:member, :moderator, :admin]
end
