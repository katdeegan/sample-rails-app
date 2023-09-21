class SessionController < ApplicationController
  def new
  end

  def create
    # params[:session] hash contains username/password
    # params[:session][:email] + params[:session][:password]
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # .authenticate method comes from has_secure_password
      reset_session
      # remember helper to remember a logged-in user
      # only remember user if they select "Remember me" checkbox
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      log_in user # login method define in session_helper.rb (included in Application Controller)
      redirect_to user #i.e. redirect_to user_url(user)
    else
      # Create an error message.
      # Active Record objects (i.e. User model) have certain error messages associated with them
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # checks if user is logged in before calling log_out
    # if user opens app in two different windows and logs out in the second window,
    # the url in the first window appears as if they are still logged in. Pressing
    # "Log out" in the first window results in an error beacuse you're now tring to log out
    # a user that is not actually logged in.
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

end
