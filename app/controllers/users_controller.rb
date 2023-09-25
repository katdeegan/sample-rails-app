class UsersController < ApplicationController
  # requires user to be logged in to access edit and update actions
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  # only admins can delete users (before_action prevents DELETE request from being executed from command line)
  before_action :admin_user,     only: :destroy

  # view all users
  # GET /users
  def index
    # User.all to pull all users from database
    #@users = User.all
    @users = User.paginate(page: params[:page])

  end

  # page to make a new user
  # GET /users/new
  def new
    @user = User.new
  end

  # view single user
  # GET /users/user_id
  def show
    @user = User.find(params[:id])
    #debugger
  end

  # create a new user
  # POST /users
  def create
    # action for POST /users API call
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      reset_session
      log_in @user
      # Default action would be to render corresponding view (i.e. views/users/create.html.erb)
      # INSTEAD, we want to redirect to a different page in app upon successful
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # automatically infers @user = user_url(@user)
    else
      # corresponding to the HTTP status code 422 Unprocessable Entity
      render 'new', status: :unprocessable_entity
    end
  end

  # page to edit specific user
  # GET /users/user_id/edit
  def edit
    @user = User.find(params[:id])
  end

  # update user
  # PATCH /users/user_id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # delete user
  # DELETE /photos/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  private
  # private method can ONLY be called from within the class that defines them (UserController)

    # extra indentation makes it visually apparent what methods are defined after private
    def user_params
      # auxiliary method that returns a version of params with only the permitted attributes
      # "strong parameters"
      # prevents command-line HTTP client from injecting params with extra attributes
      # **update only attributes that are safe to edit through the web (admin is NOT in
      # list of permitted attributes, so this parameter should NOT be editable)
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end

    # Before filters
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        # :see_other status is necessary when redirectly after a DELETE request
        redirect_to login_url, status: :see_other
      end
    end


    # Confirms the correct user. (so only users can only edit their own profile)
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
