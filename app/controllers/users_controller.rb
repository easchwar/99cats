class UsersController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = ["You did it!"]
      login_user!
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  private

  def logged_in
    @user = User.find_by_session_token(session[:session_token])
    if @user
      redirect_to cats_url
    end
  end
end
