class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user
      login_user!
      redirect_to cats_url
    else
      flash[:errors] = ['Invalid login']
      render :new
    end
  end

  def destroy
    @user = User.find_by_session_token(session[:session_token])
    session[:session_token] = nil
    @user.reset_session_token!
    redirect_to new_session_url
  end

  private

  def logged_in
    @user = User.find_by_session_token(session[:session_token])
    if @user
      redirect_to cats_url
    end
  end
end
