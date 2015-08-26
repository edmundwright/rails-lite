class ApplicationController < ControllerBase
  protect_from_forgery

  def current_user
    User.where(session_token: session[:session_token]).first
  end

  def logged_in?
    !!current_user
  end

  def log_in_user!(user)
    user.reset_session_token!
    user.save
    session[:session_token] = user.session_token
  end

  def log_out!
    current_user.reset_session_token!
    current_user.save
    session[:session_token] = nil
  end
end
