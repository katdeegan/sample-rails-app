module SessionHelper
  # Logs in the given user.
  def log_in(user)
    # temporary cookies created via session method are automatically encrypted
    session[:user_id] = user.id
  end

    # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      # using find_by here because find_by returns nil id user does not exist (whereas find() throws an exception)
      @current_user ||= User.find_by(id: session[:user_id])
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
