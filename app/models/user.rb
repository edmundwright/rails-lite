require 'bcrypt'

class User < SQLObject
  finalize!

  def save
    @errors << "Name must be present" if username.empty?
    @errors << "Password too short!" if @password && @password.length < 6
    return false if username.empty?

    super
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
  end

  def password=(new_password)
    @password = new_password
    self.password_digest = BCrypt::Password.create(new_password)
  end

  def password_matches?(given_password)
    BCrypt::Password.new(password_digest).is_password?(given_password)
  end

  def self.find_by_credentials(username, password)
    user = User.where(username: username).first

    user && user.password_matches?(password) ? user : nil
  end
end
