module SessionHelper
  # Logs in the given user.
  def log_in(user)
    # temporary cookies created via session method are automatically encrypted
    session[:user_id] = user.id
  end


  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any).
  # def current_user
  #   if session[:user_id]
  #     # using find_by here because find_by returns nil id user does not exist (whereas find() throws an exception)
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    reset_session
    @current_user = nil
  end
end