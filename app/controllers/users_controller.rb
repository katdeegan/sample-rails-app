class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    #debugger
  end

  def create
    # action for POST /users API call
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      # Default action would be to render corresponding view (i.e. views/users/create.html.erb)
      # INSTEAD, we want to redirect to a different page in app upon successful
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # automatically infers @user = user_url(@user)
    else
      # corresponding to the HTTP status code 422 Unprocessable Entity
      render 'new', status: :unprocessable_entity
    end
  end

  private
  # private method can ONLY be called from within the class that defines them (UserController)

    # extra indentation makes it visually apparent what methods are defined after private
    def user_params
      # auxiliary method that returns a version of params with only ther permitted attributes
      # "strong parameters"
      # prevents command-line HTTP client from injecting params with extra attributes
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
end
