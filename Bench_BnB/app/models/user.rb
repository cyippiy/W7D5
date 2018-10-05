class User < ApplicationRecord
  validates :password, length: {minimum: 6, presence: true}
  validates :username, :session_token, presence: true

  after_initialize :ensure_session_token

  attr_reader :password

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(pw)
    self.password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def ensure_session_token
    self.session_token ||= reset_session_token!
  end

  def self.find_by_credentials(username, password)
    @user = User.find_by(username: username)
    @user && @user.is_password?(password) ? @user : nil
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
end
