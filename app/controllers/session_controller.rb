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
    log_out
    redirect_to root_url, status: :see_other
  end

end
