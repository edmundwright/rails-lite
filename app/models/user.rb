class User < SQLObject
  finalize!

  def save
    @errors << "Name must be present" if username.empty?
    return false if username.empty?

    super
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
  end
end
